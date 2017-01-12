//
//  VerifyCodeLog.h
//
//  Created by Monkey on 15/11/25.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "NTESVCBGRLog.h"

#define LOG_LEVEL_DEF VCddLogLevel
extern BGRPrintLevel VCddLogLevel;


#ifndef LOG_ASYNC_ENABLED
    #ifndef __OPTIMIZE__
        #define LOG_ASYNC_ENABLED NO
    #else
        #define LOG_ASYNC_ENABLED YES
    #endif
#endif

/*
#define LOG_MACRO(isAsynchronous, plvl, llvl, atag, fnct, frmt, ...)  \
        [NTESVCBGRLog log : isAsynchronous                                     \
         printLevel : plvl                                               \
           logLevel : llvl                                               \
               file : __FILE__                                           \
           function : fnct                                               \
               line : __LINE__                                           \
                tag : atag                                               \
             format : (frmt), ## __VA_ARGS__]
 */

#define LOG_MACRO(isAsynchronous, llvl, fmt, ...) [NTESVCBGRLog log:isAsynchronous logLevel:llvl format:fmt, ##__VA_ARGS__]

#define LOG_MAYBE(async, plvl, llvl, frmt, ...) \
        do { if(plvl & llvl) LOG_MACRO(async, llvl, frmt, ##__VA_ARGS__);} while(0)

/**
 * Ready to use log macros with no context or tag.
 **/

// debug模式都打印; release默认都不打印,只打印workflow;设置enableLog为YES,打印info以上的
#define DDLogError(frmt, ...)      LOG_MAYBE(NO,                LOG_LEVEL_DEF, BGRLogLevelError,   frmt, ##__VA_ARGS__)
#define DDLogWarning(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, BGRLogLevelWarning, frmt, ##__VA_ARGS__)
#define DDLogInfo(frmt, ...)       LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, BGRLogLevelInfo,    frmt, ##__VA_ARGS__)
#define DDLogDebug(frmt, ...)      LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, BGRLogLevelDebug,   frmt, ##__VA_ARGS__)
#define DDLogVerbose(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, BGRLogLevelVerbose, frmt, ##__VA_ARGS__)

#define DDLogWORKFLOW(frmt, ...) NSLog( @"<WORKFLOW> VerifyCode - %@",  [NSString stringWithFormat:(frmt), ##__VA_ARGS__])
