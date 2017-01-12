//
//  BGRSTDLogger.m
//  Tools
//
//  Created by Monkey on 15/11/25.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "NTESVCBGRSTDLogger.h"
#import "NTESVCBGRLog.h"

@implementation NTESVCBGRSTDLogger

+(NTESVCBGRSTDLogger *)defaultLogger{
    static dispatch_once_t onceToken = 0;
    static NTESVCBGRSTDLogger *sharedObject = nil;
    dispatch_once(&onceToken, ^{
        sharedObject = [[NTESVCBGRSTDLogger alloc] init];
    });
    
    return sharedObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


-(void)logMessage:(VCBGRLogMessage*) logMessage{
    [self printMessage:logMessage];
}

-(void)printMessage:(VCBGRLogMessage*) logMessage{
    
    if([logMessage isByUser])
        _logFormatter = [VCBGRSTDLoggerFormatterUser sharedInstance];
    else
        _logFormatter = [VCBGRSTDLoggerFormatterDefault sharedInstance];
    
    NSString * message = _logFormatter ? [_logFormatter formatLogMessage:logMessage] : logMessage.message;
    
#if TARGET_IPHONE_SIMULATOR
    fprintf(stderr,"%s\n",[message UTF8String]);
#elif TARGET_OS_IPHONE
    printf("%s\n",[message UTF8String]);
#endif
    
}

-(void)writeToStdErr:(VCBGRLogMessage*) message{
   
}

-(NSString*)loggerName{
    return @"VerifyCode.logging.stdlogger";
}

@end

@implementation VCBGRSTDLoggerFormatterDefault{
    NSInteger _calendarUnitFlags;
    NSString* _appName;
    NSString* _processId;
}

+(VCBGRSTDLoggerFormatterDefault *)sharedInstance{
    static dispatch_once_t onceToken = 0;
    static VCBGRSTDLoggerFormatterDefault *sharedObject = nil;
    dispatch_once(&onceToken, ^{
        sharedObject = [[VCBGRSTDLoggerFormatterDefault alloc] init];
    });
    
    return sharedObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _calendarUnitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        _appName = [[NSProcessInfo processInfo] processName];
        if(![_appName length]){
            _appName = @"<UnnamedApp>";
        }
        _processId = [NSString stringWithFormat:@"%i",getpid()];
    }
    return self;
}

- (NSString *)formatLogMessage:(VCBGRLogMessage *)logMessage {
    char time[24]={0};
    if(logMessage.timestamp){
        NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
        NSDateComponents* component = [calendar components:_calendarUnitFlags fromDate:logMessage.timestamp];
        snprintf(time, 24, "%04ld-%02ld-%02ld %02ld:%02ld:%02ld.%03ld",
                 (long)component.year,
                 (long)component.month,
                 (long)component.day,
                 (long)component.hour,
                 (long)component.minute,
                 (long)component.second,
                 (long)component.nanosecond);
    }
   
    return [NSString stringWithFormat:@"%s %@[%@:%@] <%@> VerifyCode - %@",time,_appName,_processId,[logMessage threadId],[logMessage logLevelName],[logMessage message]];
}

@end

@implementation VCBGRSTDLoggerFormatterUser{
    NSInteger _calendarUnitFlags;
    NSString* _appName;
    NSString* _processId;
}

+(VCBGRSTDLoggerFormatterUser *)sharedInstance{
    static dispatch_once_t onceToken = 0;
    static VCBGRSTDLoggerFormatterUser *sharedObject = nil;
    dispatch_once(&onceToken, ^{
        sharedObject = [[VCBGRSTDLoggerFormatterUser alloc] init];
    });
    
    return sharedObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _calendarUnitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        _appName = [[NSProcessInfo processInfo] processName];
        if(![_appName length]){
            _appName = @"<UnnamedApp>";
        }
        _processId = [NSString stringWithFormat:@"%i",getpid()];

    }
    return self;
}

- (NSString *)formatLogMessage:(VCBGRLogMessage *)logMessage {
    char time[24]={0};
    if(logMessage.timestamp){
        NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
        NSDateComponents* component = [calendar components:_calendarUnitFlags fromDate:logMessage.timestamp];
        snprintf(time, 24, "%04ld-%02ld-%02ld %02ld:%02ld:%02ld.%03ld",
                 (long)component.year,
                 (long)component.month,
                 (long)component.day,
                 (long)component.hour,
                 (long)component.minute,
                 (long)component.second,
                 (long)component.nanosecond);
    }
    
    NSString *tag = [logMessage tag];
    if([tag isEqualToString:@""]){
        tag = nil;
    }else{
        tag = [NSString stringWithFormat:@"[%@]",[logMessage tag]];
    }

    return [NSString stringWithFormat:@"%s %@[%@:%@] <%@>:%@ %@",time,_appName,_processId,[logMessage threadId],[logMessage logLevelName],tag?tag:@"",[logMessage message]];
}

@end
