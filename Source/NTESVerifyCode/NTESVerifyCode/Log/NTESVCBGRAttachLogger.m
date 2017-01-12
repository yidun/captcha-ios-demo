//
//  BGRLogger.m
//  Tools
//
//  Created by Monkey on 15/11/25.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "NTESVCBGRAttachLogger.h"
#import "NTESVCBGRSafeMutableArray.h"
#import "NTESVCBGRLog.h"

#define MAX_LOG_LENGTH 30000
#define MAC_LOG_SIZE   200

@implementation NTESVCBGRAttachLogger

+(NTESVCBGRAttachLogger *)defaultLogger{
    static dispatch_once_t onceToken = 0;
    static NTESVCBGRAttachLogger *sharedObject = nil;
    dispatch_once(&onceToken, ^{
        sharedObject = [[NTESVCBGRAttachLogger alloc] init];
    });
    
    return sharedObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _calendarUnitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        _logArr = [[NTESVCBGRSafeMutableArray alloc] initWithCapacity:200];
    }
    return self;
}

-(void)logMessage:(VCBGRLogMessage *)message{
    if([message isByUser]){
        char time[24]={0};
        if(message.timestamp){
            NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
            NSDateComponents* component = [calendar components:_calendarUnitFlags fromDate:message.timestamp];
            snprintf(time, 24, "%02ld-%02ld-%02ld %02ld:%02ld:%02ld",
                     (long)component.year,
                     (long)component.month,
                     (long)component.day,
                     (long)component.hour,
                     (long)component.minute,
                     (long)component.second);
        }
        
        NSString* log = [NSString stringWithFormat:@"%s %@ %@ %@: %@",
                         time,
                         message.processId,
                         @"-",
                         [self convertLogLevelName:message.logLevel],
                         message.message];
        
        [self addLog:log];

    }
}

-(NSString *)convertLogLevelName:(BGRLogLevel) logLevel{
    
    NSString *logLevelName = nil;
    switch (logLevel) {
        case BGRLogLevelSilent:
            logLevelName = @"S";
            break;
        case BGRLogLevelWarning:
            logLevelName = @"W";
            break;
        case BGRLogLevelDebug:
            logLevelName = @"D";
            break;
        case BGRLogLevelError:
            logLevelName = @"E";
            break;
        case BGRLogLevelInfo:
            logLevelName = @"I";
            break;
            
        case BGRLogLevelVerbose:
            logLevelName = @"V";
            break;
        default:
            logLevelName = @"U";
            break;
    }
    
    return logLevelName;
}

-(void)didAddLogger{
    
}

-(void)willRemoveLogger{
    
}

-(void)addLog:(NSString*)log{
    @synchronized (self.logArr) {
        while ([log length] + _logSize >= MAX_LOG_LENGTH) {
            NSUInteger length = [[_logArr objectAtIndex:0] length];
            [_logArr removeObjectAtIndex:0];
            _logSize -= length;
        }
        
        [_logArr addObject:log];
        _logSize += [log length];
        
        if([_logArr count] >= MAC_LOG_SIZE){
            [_logArr removeObjectsInRange:NSMakeRange(0, [_logArr count] / 5)];
        }
    }
}

-(NSString *)logs{
        return [_logArr componentsJoinedByString:@"\r\n"];
    return nil;
}

- (void) clear {
    @synchronized (self.logArr) {
        [self.logArr removeAllObjects];
    }
}

-(NSString *)loggerName{
    return @"VerifyCode.logging.logger";
}

@end
