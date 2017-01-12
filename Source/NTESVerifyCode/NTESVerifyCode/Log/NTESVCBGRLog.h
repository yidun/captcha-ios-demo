//
//  NTESVCBGRLog.h
//  Tools
//
//  Created by Monkey on 15/11/25.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

// Log level for VerifyCode Logger
typedef NS_ENUM(NSUInteger, BGRLogLevel) {
    BGRLogLevelSilent    = 0,      // 00000
    BGRLogLevelError     = 1 << 0, // 00001
    BGRLogLevelWarning   = 1 << 1, // 00010
    BGRLogLevelInfo      = 1 << 2, // 00100
    BGRLogLevelDebug     = 1 << 3, // 01000
    BGRLogLevelVerbose   = 1 << 4, // 10000
};

typedef NS_ENUM(NSUInteger, BGRPrintLevel) {
    BGRPrintLevelOff       = 0,
    BGRPrintLevelError     = (BGRLogLevelError),                          // 0...00001
    BGRPrintLevelWarning   = (BGRPrintLevelError   | BGRLogLevelWarning), // 0...00011
    BGRPrintLevelInfo      = (BGRPrintLevelWarning | BGRLogLevelInfo),    // 0...00111
    BGRPrintLevelDebug     = (BGRPrintLevelInfo    | BGRLogLevelDebug),   // 0...01111
    BGRPrintLevelVerbose   = (BGRPrintLevelDebug   | BGRLogLevelVerbose), // 0...11111
    BGRPrintLevelAll       = NSUIntegerMax                                // 1111....11111 (BGRLogFlagVerbose plus any other flags)
};

@class BGRLogger;
@class BGRAbstractLogger;
@protocol NTESVCBGRLoggerDelegate;

@interface NTESVCBGRLog : NSObject

+ (BOOL)initByUser;

+ (dispatch_queue_t)loggingQueue;

+ (void)removeAllLoggers;

+ (void)addLogger:(id <NTESVCBGRLoggerDelegate>) logger;

+ (void)removeLogger:(id <NTESVCBGRLoggerDelegate>) logger;

+ (NSArray *)allLoggers;

+ (void)log:(NSString*) message
   logLevel:(BGRLogLevel) logLevel
       file:(const char*) file
   function:(const char*) function
       line:(NSInteger) line
        tag:(NSString*)tag
     byUser:(BOOL) byUser;

+ (void)log:(BOOL) asynchronous
   logLevel:(BGRLogLevel) logLevel
     format:(NSString *)format, ... NS_FORMAT_FUNCTION(3,4);

+ (void)log:(BOOL)asynchronous
 printLevel:(BGRPrintLevel)printLevel
   logLevel:(BGRLogLevel)logLevel
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
        tag:(NSString *)tag
     format:(NSString *)format, ... NS_FORMAT_FUNCTION(8,9);

+ (void)log:(BOOL)asynchronous
    message:(NSString *)message
 printLevel:(BGRPrintLevel)printLevel
   logLevel:(BGRLogLevel)logLevel
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
        tag:(NSString *)tag
     byUser:(BOOL)byUser;

@end

@interface VCBGRLogMessage : NSObject{
@public
    NSString *_message;
    BGRPrintLevel _printLevel;
    BGRLogLevel _logLevel;
    NSString *_file;
    NSString *_fileName;
    NSString *_function;
    NSString *_line;
    NSString *_tag;
    NSDate   *_timestamp;
    NSString *_threadID;
    NSString *_threadName;
    NSString *_processId;
    NSString *_logLevelName;
    NSString *_logLevelFullName;
}

@property (readonly, nonatomic) NSString *message;
@property (readonly, nonatomic) BGRPrintLevel printLevel;
@property (readonly, nonatomic) BGRLogLevel logLevel;
@property (readonly, nonatomic) NSDate* timestamp;
@property (readonly, nonatomic) NSString* file;
@property (readonly, nonatomic) NSString* fileName;
@property (readonly, nonatomic) NSString* function;
@property (readonly, nonatomic) NSString* line;
@property (readonly, nonatomic) NSString* processId;
@property (readonly, nonatomic) NSString* threadId;
@property (readonly, nonatomic) NSString* threadName;
@property (readonly, nonatomic) NSString* logLevelName;
@property (readonly, nonatomic) NSString* logLevelFullName;
@property (readonly, nonatomic) NSString* tag;
@property (readonly, nonatomic) BOOL byUser;

- (VCBGRLogMessage*)initWithMessage:(NSString*) message
                       printLevel:(BGRPrintLevel)printLevel
                         logLevel:(BGRLogLevel)logLevel
                             file:(NSString *)file
                         function:(NSString *)function
                             line:(NSString *)line
                              tag:(id)tag
                        timestamp:(NSDate*) timestamp
                           byUser:(BOOL) byUser;

-(BOOL)isByUser;

-(id)copyWithZone:(NSZone *)zone;

@end

@interface VCBGRLoggerInfo : NSObject{
@public
    id <NTESVCBGRLoggerDelegate> _logger;
    BGRPrintLevel _printLevel;
    dispatch_queue_t _loggerQueue;
}

@property(nonatomic,readonly) id<NTESVCBGRLoggerDelegate> logger;
@property(nonatomic,readonly) BGRPrintLevel printLevel;
@property(nonatomic,readonly) dispatch_queue_t loggerQueue;

+(VCBGRLoggerInfo *)infoWithLogger:(id <NTESVCBGRLoggerDelegate>) logger level:(BGRPrintLevel) printLevel queue:(dispatch_queue_t) queue;

@end

@protocol NTESVCBGRLoggerDelegate <NSObject>

-(void)logMessage:(VCBGRLogMessage *) message;

@optional

-(void)didAddLogger;

-(void)willRemoveLogger;

-(void)flush;

@property (nonatomic, strong, readonly) dispatch_queue_t loggerQueue;

@property (nonatomic, readonly) NSString *loggerName;

@end

@protocol DDLogFormatter <NSObject>
@required

- (NSString *)formatLogMessage:(VCBGRLogMessage *)logMessage;

@optional

- (void)didAddToLogger:(id <NTESVCBGRLoggerDelegate>)logger;
- (void)willRemoveFromLogger:(id <NTESVCBGRLoggerDelegate>)logger;

@end

@interface NTESVCBGRAbstractLogger : NSObject<NTESVCBGRLoggerDelegate>{
    @public
    id <DDLogFormatter> _logFormatter;
    dispatch_queue_t _loggerQueue;
}

@property (nonatomic, strong) id <DDLogFormatter> logFormatter;
@property (nonatomic, strong) dispatch_queue_t loggerQueue;

@property (nonatomic, readonly, getter=isOnGlobalLoggingQueue)  BOOL onGlobalLoggingQueue;
@property (nonatomic, readonly, getter=isOnInternalLoggerQueue) BOOL onInternalLoggerQueue;

@end
