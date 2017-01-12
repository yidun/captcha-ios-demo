//
//  NTESVCBGRLog.m
//  Tools
//
//  Created by Monkey on 15/11/25.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "NTESVCBGRLog.h"
#import <pthread.h>
#import <mach/mach_host.h>
#import "NTESVCBGRAttachLogger.h"
#import "NTESVCBGRSTDLogger.h"
#import "NTESVCBGRASLLogger.h"

BGRPrintLevel VCddLogLevel = BGRPrintLevelOff;

#define LOG_MAX_QUEUE_SIZE 1000 // Should not exceed INT32_MAX

static void *const GlobalLoggingQueueIdentityKey = (void *)&GlobalLoggingQueueIdentityKey;

@implementation NTESVCBGRLog

static NSMutableArray* _loggers;
static dispatch_queue_t _loggingQueue;
static dispatch_group_t _loggingGroup;
static dispatch_semaphore_t _queueSemaphore;
static NSUInteger _numProcessors;

+ (void)initialize
{
    if (self == [NTESVCBGRLog class]) {
        static dispatch_once_t onceToken = 0;
        dispatch_once(&onceToken, ^{
            _loggers = [[NSMutableArray alloc] initWithCapacity:4];
            
            _loggingQueue = dispatch_queue_create("VerifyCode.logging", 0);
            _loggingGroup = dispatch_group_create();
            
            void *nonNullValue = GlobalLoggingQueueIdentityKey; // Whatever, just not null
            dispatch_queue_set_specific(_loggingQueue, GlobalLoggingQueueIdentityKey, nonNullValue, NULL);
            
            _queueSemaphore = dispatch_semaphore_create(LOG_MAX_QUEUE_SIZE);
            
            host_basic_info_data_t hostInfo;
            mach_msg_type_number_t infoCount;
            
            infoCount = HOST_BASIC_INFO_COUNT;
            host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount);
            
            NSUInteger result = (NSUInteger)hostInfo.max_cpus;
            NSUInteger one    = (NSUInteger)1;
            
            _numProcessors = MAX(result, one);

            [NTESVCBGRLog addLogger:[NTESVCBGRSTDLogger defaultLogger]];
            //[NTESVCBGRLog addLogger:[NTESVCBGRASLLogger defaultLogger]];
        });
    }
}

+(dispatch_queue_t)loggingQueue{
    return _loggingQueue;
}

+(void)removeAllLoggers{
    dispatch_async(_loggingQueue, ^{
        [NTESVCBGRLog cleanAllLoggers];
    });
}

+(void)removeLogger:(id <NTESVCBGRLoggerDelegate>)logger{
    dispatch_async(_loggingQueue, ^{
        [NTESVCBGRLog removeLoggerFromQueue:logger];
    });
}


+(void)addLogger:(id <NTESVCBGRLoggerDelegate>)logger{
    dispatch_async(_loggingQueue, ^{
        [NTESVCBGRLog addLoggerToQueue:logger];
    });
}

+(NSArray *)allLoggers{
    __block NSArray *theLoggers;
    
    dispatch_sync(_loggingQueue, ^{ @autoreleasepool {
        theLoggers = [self getAllLogger];
    } });
    
    return theLoggers;
}

+(NSArray*)getAllLogger{
    NSAssert(dispatch_get_specific(GlobalLoggingQueueIdentityKey),
             @"This method should only be run on the logging thread/queue");
    
    NSMutableArray *theLoggers = [NSMutableArray new];
    
    for (VCBGRLoggerInfo *loggerNode in _loggers) {
        [theLoggers addObject:loggerNode.logger];
    }
    
    return [theLoggers copy];
}

+(void)removeLoggerFromQueue:(id <NTESVCBGRLoggerDelegate>)logger{
    
    NSAssert(dispatch_get_specific(GlobalLoggingQueueIdentityKey),
             @"This method should only be run on the logging thread/queue");
    VCBGRLoggerInfo *loggerNode = nil;
    
    for (VCBGRLoggerInfo *node in _loggers) {
        if (node.logger == logger) {
            loggerNode = node;
            break;
        }
    }
    
    if (loggerNode == nil) {
        NSLog(@"Request to remove logger which wasn't added");
        return;
    }
    
    // Notify logger
    if ([logger respondsToSelector:@selector(willRemoveLogger)]) {
        dispatch_async(loggerNode.loggerQueue, ^{ @autoreleasepool {
            [logger willRemoveLogger];
        } });
    }
    
    // Remove from loggers array
    [_loggers removeObject:loggerNode];
}

+(void)addLoggerToQueue:(id <NTESVCBGRLoggerDelegate>)logger{
    
    NSAssert(dispatch_get_specific(GlobalLoggingQueueIdentityKey),
             @"This method should only be run on the logging thread/queue");
    
    dispatch_queue_t loggerQueue = NULL;
    
    if ([logger respondsToSelector:@selector(loggerQueue)]) {
        // Logger may be providing its own queue
        
        loggerQueue = [logger loggerQueue];
    }
    
    if (loggerQueue == nil) {
        // Automatically create queue for the logger.
        // Use the logger name as the queue name if possible.
        
        const char *loggerQueueName = NULL;
        
        if ([logger respondsToSelector:@selector(loggerName)]) {
            loggerQueueName = [[logger loggerName] UTF8String];
        }
        
        loggerQueue = dispatch_queue_create(loggerQueueName, NULL);
    }
    
    VCBGRLoggerInfo* loggerNode = [VCBGRLoggerInfo infoWithLogger:logger level:BGRPrintLevelAll queue:loggerQueue];
    [_loggers addObject:loggerNode];
    
    if([logger respondsToSelector:@selector(didAddLogger)]){
        dispatch_async(loggerNode.loggerQueue, ^{
            [logger didAddLogger];
        });
    }
}

+(void)cleanAllLoggers{
    NSAssert(dispatch_get_specific(GlobalLoggingQueueIdentityKey),
             @"This method should only be run on the logging thread/queue");
    
    // Notify all loggers
    for (VCBGRLoggerInfo *loggerNode in _loggers) {
        if ([loggerNode.logger respondsToSelector:@selector(willRemoveLogger)]) {
            dispatch_async(loggerNode.loggerQueue, ^{ @autoreleasepool {
                [loggerNode.logger willRemoveLogger];
            } });
        }
    }
    
    // Remove all loggers from array
    
    [_loggers removeAllObjects];
}

+(void)log:(NSString *)message
  logLevel:(BGRLogLevel)logLevel
      file:(const char *)file
  function:(const char *)function
      line:(NSInteger)line
       tag:(NSString *)tag
    byUser:(BOOL) byUser{
    if(message){
        VCBGRLogMessage* logMessage = [[VCBGRLogMessage alloc] initWithMessage:message
                                                                printLevel:BGRPrintLevelAll
                                                                  logLevel:logLevel
                                                                      file:file?[NSString stringWithUTF8String:file]:@""
                                                                  function:function?[NSString stringWithUTF8String:function]:@""
                                                                      line:line?[NSString stringWithFormat:@"%zi",line]:@""
                                                                       tag:tag?tag:@""
                                                                 timestamp:nil
                                                                    byUser:byUser];

        [NTESVCBGRLog queueLogMessage:logMessage asynchronously:YES];
    }
}

+(void)log:(BOOL)asynchronous
  logLevel:(BGRLogLevel)logLevel
    format:(NSString *)format, ...{
    va_list args;
    
    if (format) {
        va_start(args, format);
        
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [self log:asynchronous
          message:message
       printLevel:BGRPrintLevelAll
         logLevel:logLevel
             file:""
         function:""
             line:0
              tag:nil
           byUser:NO];
        
        va_end(args);
    }
}

+ (void)log:(BOOL)asynchronous
 printLevel:(BGRPrintLevel)printLevel
   logLevel:(BGRLogLevel)logLevel
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
        tag:(NSString *)tag
     format:(NSString *)format, ...{
    va_list args;
    
    if (format) {
        va_start(args, format);
        
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [self log:asynchronous
          message:message
       printLevel:printLevel
         logLevel:logLevel
             file:file
         function:function
             line:line
              tag:tag
           byUser:NO];
        
        va_end(args);
    }
}

+ (void)log:(BOOL)asynchronous
    message:(NSString *)message
 printLevel:(BGRPrintLevel)printLevel
   logLevel:(BGRLogLevel)logLevel
       file:(const char *)file
   function:(const char *)function
       line:(NSUInteger)line
        tag:(NSString *)tag
     byUser:(BOOL) byUser{
    VCBGRLogMessage *logMessage = [[VCBGRLogMessage alloc] initWithMessage:message
                                                            printLevel:printLevel
                                                              logLevel:logLevel
                                                                  file:[NSString stringWithFormat:@"%s", file]
                                                              function:[NSString stringWithFormat:@"%s", function]
                                                                  line:[NSString stringWithFormat:@"%zi", line]
                                                                   tag:tag?tag:@""
                                                             timestamp:nil
                                                                byUser:byUser];
    
    [self queueLogMessage:logMessage asynchronously:asynchronous];
}

+ (void)queueLogMessage:(VCBGRLogMessage *)logMessage asynchronously:(BOOL)asyncFlag {
    
    dispatch_semaphore_wait(_queueSemaphore, DISPATCH_TIME_FOREVER);
    
    // We've now sure we won't overflow the queue.
    // It is time to queue our log message.
    
    dispatch_block_t logBlock = ^{
        @autoreleasepool {
            [self printLog:logMessage];
        }
    };
    
    if (asyncFlag) {
        dispatch_async(_loggingQueue, logBlock);
    } else {
        dispatch_sync(_loggingQueue, logBlock);
    }
}

+(void)printLog:(VCBGRLogMessage*) logMessage{
    NSAssert(dispatch_get_specific(GlobalLoggingQueueIdentityKey),
             @"This method should only be run on the logging thread/queue");
    
    if (_numProcessors > 1) {
        // Execute each logger concurrently, each within its own queue.
        // All blocks are added to same group.
        // After each block has been queued, wait on group.
        //
        // The waiting ensures that a slow logger doesn't end up with a large queue of pending log messages.
        // This would defeat the purpose of the efforts we made earlier to restrict the max queue size.
        
        for (VCBGRLoggerInfo *loggerNode in _loggers) {
            // skip the loggers that shouldn't write this message based on the log level
            
            if (!(logMessage->_logLevel & loggerNode->_printLevel)) {
                continue;
            }
            
            
            
            dispatch_group_async(_loggingGroup, loggerNode->_loggerQueue, ^{ @autoreleasepool {
                [loggerNode->_logger logMessage:logMessage];
            } });
        }
        
        dispatch_group_wait(_loggingGroup, DISPATCH_TIME_FOREVER);
    } else {
        // Execute each logger serialy, each within its own queue.
        
        for (VCBGRLoggerInfo *loggerNode in _loggers) {
            // skip the loggers that shouldn't write this message based on the log level
            
            if (!(logMessage->_logLevel & loggerNode->_printLevel)) {
                continue;
            }
            
            dispatch_sync(loggerNode->_loggerQueue, ^{ @autoreleasepool {
                [loggerNode->_logger logMessage:logMessage];
            } });
        }
    }

    
    dispatch_semaphore_signal(_queueSemaphore);
}

+ (BOOL)initByUser{
    NSArray* loggers = [NTESVCBGRLog allLoggers];
    for (id <NTESVCBGRLoggerDelegate> logger in loggers) {
        NSString* className = [NSString stringWithUTF8String:object_getClassName(logger)];
        if([className isEqualToString:@"NTESVCBGRAttachLogger"]){
            return YES;
        }
    }
    return NO;
}

@end

@implementation VCBGRLoggerInfo

+(VCBGRLoggerInfo *)infoWithLogger:(id <NTESVCBGRLoggerDelegate>) logger level:(BGRPrintLevel) printLevel queue:(dispatch_queue_t) queue{
    return [[VCBGRLoggerInfo alloc] initWithLogger:logger level:printLevel queue:queue];
}

-(VCBGRLoggerInfo *)initWithLogger:(id <NTESVCBGRLoggerDelegate>)logger level:(BGRPrintLevel) printLevel queue:(dispatch_queue_t) queue{
    self = [super init];
    if(self){
        _logger = logger;
        _printLevel = printLevel;
        if(queue){
            _loggerQueue = queue;
        }
    }
    return self;
}

@end

@implementation VCBGRLogMessage

-(id)copyWithZone:(NSZone *)zone{
    VCBGRLogMessage* newMessage = [VCBGRLogMessage new];
    
    newMessage->_message            = _message;
    newMessage->_printLevel         = _printLevel;
    newMessage->_logLevel           = _logLevel;
    newMessage->_file               = _file;
    newMessage->_fileName           = _fileName;
    newMessage->_function           = _function;
    newMessage->_line               = _line;
    newMessage->_tag                = _tag;
    newMessage->_timestamp          = _timestamp;
    newMessage->_threadID           = _threadID;
    newMessage->_threadName         = _threadName;
    newMessage->_processId          = _processId;
    newMessage->_logLevelName       = _logLevelName;
    newMessage->_logLevelFullName   = _logLevelFullName;
    
    return newMessage;
}

- (VCBGRLogMessage*)initWithMessage:(NSString*) message
                       printLevel:(BGRPrintLevel)printLevel
                         logLevel:(BGRLogLevel)logLevel
                             file:(NSString *)file
                         function:(NSString *)function
                             line:(NSString *)line
                              tag:(id)tag
                        timestamp:(NSDate*) timestamp
                           byUser:(BOOL)byUser{
    if ((self = [super init])) {
        _message      = [message copy];
        _printLevel   = printLevel;
        _logLevel     = logLevel;
        _file         = file;
        _function     = function;
        _line         = line;
        _tag          = tag;
        _byUser       = byUser;
        _timestamp    = timestamp ?: [NSDate new];
        _threadID     = [[NSString alloc] initWithFormat:@"%x", pthread_mach_thread_np(pthread_self())];
        _threadName   = NSThread.currentThread.name;
        _processId = [NSString stringWithFormat:@"%d",[[NSProcessInfo processInfo] processIdentifier]];
        
        // Get the file name without extension
        if(_file.length){
            _fileName = [_file lastPathComponent];
            NSUInteger dotLocation = [_fileName rangeOfString:@"." options:NSBackwardsSearch].location;
            if (dotLocation != NSNotFound)
            {
                _fileName = [_fileName substringToIndex:dotLocation];
            }
        }
        
        if(kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_8_0){
            _threadId = [NSString stringWithFormat:@"%x",pthread_mach_thread_np(pthread_self())];
        }else{
            unsigned long long threadId;
            pthread_threadid_np(0, &threadId);
            _threadId = [NSString stringWithFormat:@"%llu",threadId];
        }
        
        switch (_logLevel) {
            case BGRLogLevelSilent:
                _logLevelName = @"Silent";
                _logLevelFullName = @"VerifyCodeLogLevelSilent";
                break;
            case BGRLogLevelWarning:
                _logLevelName = @"Warning";
                _logLevelFullName = @"VerifyCodeLogLevelWarn";
                break;
            case BGRLogLevelDebug:
                _logLevelName = @"Debug";
                _logLevelFullName = @"VerifyCodeLogLevelDebug";
                break;
            case BGRLogLevelError:
                _logLevelName = @"Error";
                _logLevelFullName = @"VerifyCodeLogLevelError";
                break;
            case BGRLogLevelInfo:
                _logLevelName = @"Info";
                _logLevelFullName = @"VerifyCodeLogLevelInfo";
                break;
                
            case BGRLogLevelVerbose:
                _logLevelName = @"Verbose";
                _logLevelFullName = @"VerifyCodeLogLevelVerbose";
                break;
            default:
                _logLevelName = @"Unknow";
                _logLevelFullName = @"Unknow";
                break;
        }
    }
    return self;
}

-(BOOL)isByUser{
    return _byUser;
}

@end

@implementation NTESVCBGRAbstractLogger

- (instancetype)init
{
    self = [super init];
    if (self) {
        const char *loggerQueueName = NULL;
        
        if ([self respondsToSelector:@selector(loggerName)]) {
            loggerQueueName = [[self loggerName] UTF8String];
        }
        
        _loggerQueue = dispatch_queue_create(loggerQueueName, NULL);

        void *key = (__bridge void *)self;
        void *nonNullValue = (__bridge void *)self;
        
        dispatch_queue_set_specific(_loggerQueue, key, nonNullValue, NULL);
    }
    return self;
}

-(NSString *)loggerName{
    return NSStringFromClass([self class]);
}

- (dispatch_queue_t)loggerQueue {
    return _loggerQueue;
}

-(void)setLoggerQueue:(dispatch_queue_t)loggerQueue{
    _loggerQueue = loggerQueue;
}

-(BOOL)isOnGlobalLoggingQueue{
    return (dispatch_get_specific(GlobalLoggingQueueIdentityKey) != NULL);
}

-(BOOL)isOnInternalLoggerQueue{
    void *key = (__bridge void *)self;
    
    return (dispatch_get_specific(key) != NULL);
}

-(void)logMessage:(VCBGRLogMessage *)message{
    // Override me
}

- (id<DDLogFormatter>)logFormatter{
    NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
    NSAssert(![self isOnInternalLoggerQueue], @"MUST access ivar directly, NOT via self.* syntax.");
    
    dispatch_queue_t globalLoggingQueue = [NTESVCBGRLog loggingQueue];
    
    __block id <DDLogFormatter> result;
    
    dispatch_sync(globalLoggingQueue, ^{
        dispatch_sync(_loggerQueue, ^{
            result = _logFormatter;
        });
    });
    
    return result;
}

- (void)setLogFormatter:(id <DDLogFormatter>)logFormatter {
    // The design of this method is documented extensively in the logFormatter message (above in code).
    
    NSAssert(![self isOnGlobalLoggingQueue], @"Core architecture requirement failure");
    NSAssert(![self isOnInternalLoggerQueue], @"MUST access ivar directly, NOT via self.* syntax.");
    
    dispatch_block_t block = ^{
        @autoreleasepool {
            if (_logFormatter != logFormatter) {
                if ([_logFormatter respondsToSelector:@selector(willRemoveFromLogger:)]) {
                    [_logFormatter willRemoveFromLogger:self];
                }
                
                _logFormatter = logFormatter;
                
                if ([_logFormatter respondsToSelector:@selector(didAddToLogger:)]) {
                    [_logFormatter didAddToLogger:self];
                }
            }
        }
    };
    
    dispatch_queue_t globalLoggingQueue = [NTESVCBGRLog loggingQueue];
    
    dispatch_async(globalLoggingQueue, ^{
        dispatch_async(_loggerQueue, block);
    });
}


@end
