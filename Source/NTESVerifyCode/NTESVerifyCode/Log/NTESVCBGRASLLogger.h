//
//  BGRASLLogger.h
//  Tools
//
//  Created by Monkey on 15/11/25.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESVCBGRLog.h"

@interface NTESVCBGRASLLogger : NTESVCBGRAbstractLogger<NTESVCBGRLoggerDelegate>

+(NTESVCBGRASLLogger*)defaultLogger;

@end

@interface VCBGRASLLoggerFormatterDefault : NSObject <DDLogFormatter>

@end
