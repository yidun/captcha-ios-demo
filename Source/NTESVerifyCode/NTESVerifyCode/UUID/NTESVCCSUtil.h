//
//  NTESVCCSUtil.h
//  UUID
//
//  Created by NetEase on 16/12/14.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESVCCSDefine.h"

#define UUIDUtiler NTESVCCSUtil

#ifdef __OPTIMIZE__
#define NTESVCCSUtil HEXvDJXFpeSmkMiRdf
#define genErrorString_CS_UUID RgfDbIllxvBwfrnK
#endif

@interface NTESVCCSUtil : NSObject

+ (NSString *)genErrorString_CS_UUID:(NTESVCCSErrorCode)error;

@end
