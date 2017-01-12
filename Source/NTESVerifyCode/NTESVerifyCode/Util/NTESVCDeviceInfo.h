//
//  NTESVCDeviceInfo.h
//  VerifyCode
//
//  Created by Monkey on 15/12/25.
//  Copyright © 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESVCCSUUID.h"
#import "NTESVCDefines.h"

@interface NTESVCDeviceInfo : NSObject

#pragma mark 设备信息

@property (strong, nonatomic) NSString *captchaId;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) BOOL debug;
@property (assign, nonatomic) NSInteger width;

#pragma mark 用户配置信息

@property (assign, nonatomic)NSTimeInterval timeout;
@property (strong, nonatomic)NSURL *baseUrl;

#pragma mark methods

+ (NTESVCDeviceInfo *)sharedInstance;

- (NSString *)getDeviceId;
- (NSString *)getOS;
- (NSString *)getOSVer;
- (NSString *)getSDKVer;
- (VCDeviceOrientation)getDeviceOrientation;

@end
