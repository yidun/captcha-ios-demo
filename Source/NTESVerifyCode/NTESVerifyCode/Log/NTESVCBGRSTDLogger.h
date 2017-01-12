//
//  BGRSTDLogger.h
//  Tools
//
//  Created by Monkey on 15/11/25.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESVCBGRLog.h"

@interface NTESVCBGRSTDLogger : NTESVCBGRAbstractLogger

+(NTESVCBGRSTDLogger*)defaultLogger;

@end

@interface VCBGRSTDLoggerFormatterDefault : NSObject <DDLogFormatter>

+(VCBGRSTDLoggerFormatterDefault *)sharedInstance;

@end

@interface VCBGRSTDLoggerFormatterUser : NSObject <DDLogFormatter>

+(VCBGRSTDLoggerFormatterUser *)sharedInstance;

@end
