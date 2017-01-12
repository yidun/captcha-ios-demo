//
//  NTESVerifyCodeDeviceUtil.m
//  VerifyCode
//
//  Created by Monkey on 15/12/25.
//  Copyright © 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/sysctl.h>
#import <mach-o/arch.h>
#import <mach-o/dyld.h>
#import <time.h>
#import <sys/mount.h>
#import <mach/mach.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#import "NTESVCDeviceInfo.h"
#import "NTESVCDefines.h"
#import "NTESVCJailbreakCheck.h"
#import "../Log/NTESVCPrintLog.h"


@implementation NTESVCDeviceInfo

+ (NTESVCDeviceInfo *)sharedInstance
{
    static dispatch_once_t onceToken = 0;
    static NTESVCDeviceInfo *sharedObject = nil;
    dispatch_once(&onceToken, ^{
        sharedObject = [[NTESVCDeviceInfo alloc] init];
        sharedObject.timeout = VERIFTCODE_TIMEOUT;
    });
    
    return sharedObject;
}

- (NSString *)getDeviceId{
    return [NTESVCCSUUID getUUID];
}

- (NSString *)getOS{
    return [[UIDevice currentDevice] systemName];
}

- (NSString *)getOSVer{
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"];
    
    NSString* sysBuildVer = nil;
    
    if(dic){
        sysBuildVer = [dic objectForKey:@"ProductBuildVersion"];
    }
    
    NSString* systemVersion = [[UIDevice currentDevice] systemVersion];
    
    if(sysBuildVer){
        return [NSString stringWithFormat:@"%@(%@)",systemVersion,sysBuildVer];
    }
    
    return systemVersion;
}

- (NSString *)getSDKVer{
    return VerifyCode_IOS_SDK_VERSION;
}

- (VCDeviceOrientation)getDeviceOrientation{
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
    VCDeviceOrientation vcOrient = VCDeviceOrientationLandscape;
    switch (orient)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        vcOrient = VCDeviceOrientationPortrait;
        break;
        default:
        break;
    }
    
    return vcOrient;
}

@end
