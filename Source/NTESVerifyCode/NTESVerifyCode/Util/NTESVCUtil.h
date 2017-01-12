//
//  NTESVCUtil.h
//  NTESVerifyCode
//
//  Created by NetEase on 16/12/7.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTESVCUtil : NSObject

// url encode
+ (NSString *)urlEncode:(NSString*)string;

+ (BOOL)isNetworkReachable;

@end
