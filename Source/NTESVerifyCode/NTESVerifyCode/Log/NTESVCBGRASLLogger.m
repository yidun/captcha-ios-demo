//
//  BGRASLLogger.m
//  Tools
//
//  Created by Monkey on 15/11/25.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "NTESVCBGRASLLogger.h"
#import "NTESVCBGRLog.h"
#import "NTESVCBGRLog.h"
#import <asl.h>

@implementation NTESVCBGRASLLogger{
    asl_object_t _client;
}

+(NTESVCBGRASLLogger *)defaultLogger{
    static dispatch_once_t onceToken = 0;
    static NTESVCBGRASLLogger *sharedObject = nil;
    dispatch_once(&onceToken, ^{
        sharedObject = [[NTESVCBGRASLLogger alloc] init];
    });
    
    return sharedObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _client = asl_open(NULL, "com.apple.console", 0);
        self.logFormatter = [VCBGRASLLoggerFormatterDefault new];
    }
    return self;
}

-(void)logMessage:(VCBGRLogMessage*) logMessage{
    NSString * message = [logMessage message];
    
    if(![logMessage isByUser]){
        message = _logFormatter ? [_logFormatter formatLogMessage:logMessage] : logMessage.message;
    }
    
    if(logMessage){
        const char *msg = [message UTF8String];

        size_t aslLogLevel = ASL_LEVEL_NOTICE;
        switch (logMessage.logLevel) {
            case BGRLogLevelError        : aslLogLevel = ASL_LEVEL_ERR;     break;
            case BGRLogLevelWarning      : aslLogLevel = ASL_LEVEL_WARNING;      break;
            case BGRLogLevelInfo         : //aslLogLevel = ASL_LEVEL_INFO;  break; // Regular NSLog's level
            case BGRLogLevelDebug        : //aslLogLevel = ASL_LEVEL_DEBUG;  break;
            case BGRLogLevelVerbose      :
            default                         : aslLogLevel = ASL_LEVEL_NOTICE;   break;
        }
        
        static char const *const level_strings[] = { "0", "1", "2", "3", "4", "5", "6", "7" };
        
        // NSLog uses the current euid to set the ASL_KEY_READ_UID.
        uid_t const readUID = geteuid();
        
        char readUIDString[16];
#ifndef NS_BLOCK_ASSERTIONS
        int l = snprintf(readUIDString, sizeof(readUIDString), "%d", readUID);
#else
        snprintf(readUIDString, sizeof(readUIDString), "%d", readUID);
#endif
        
        NSAssert(l < sizeof(readUIDString),
                 @"Formatted euid is too long.");
        NSAssert(aslLogLevel < (sizeof(level_strings) / sizeof(level_strings[0])),
                 @"Unhandled ASL log level.");
        
        asl_object_t asl_msg = asl_new(ASL_TYPE_MSG);
        if(asl_msg != NULL){
            if(asl_set(asl_msg, ASL_KEY_LEVEL, level_strings[aslLogLevel]) == 0 &&
               asl_set(asl_msg, ASL_KEY_MSG, msg) == 0 &&
               asl_set(asl_msg, ASL_KEY_READ_UID, readUIDString) == 0){
                asl_send(_client, asl_msg);
            }
            asl_free(asl_msg);
        }
    }
}

-(NSString*)loggerName{
    return @"VerifyCode.logging.asllogger";
}

-(void)dealloc{
    asl_close(_client);
}

@end

@implementation VCBGRASLLoggerFormatterDefault

- (NSString *)formatLogMessage:(VCBGRLogMessage *)logMessage {
    NSString* formatString = nil;

    formatString = [NSString stringWithFormat:@"VerifyCode - %@",logMessage.message];
    return formatString;
}

@end
