//
//  NTESVCDefines.h
//  VerifyCode
//
//  Created by Monkey on 15-6-25.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#ifndef VerifyCode_NTESVCDefines_h
#define VerifyCode_NTESVCDefines_h

#define VerifyCode_IOS_SDK_VERSION      @"2.0.1"

#define NSSTRINGFROMCSTR(cstr) [NSString stringWithUTF8String:cstr]

// 常见的系统有关的宏定义
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上
#define SCREEN_WIDTH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define SCREENH_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define SCREEN_SIZE ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#endif

//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])
// 判断是否为 iPhone 5SE
#define iPhone5SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f
// 判断是否为iPhone 6/6s
#define iPhone6_6s [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f
// 判断是否为iPhone 6Plus/6sPlus
#define iPhone6Plus_6sPlus [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f
//获取系统版本
#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//判断 iOS 8 或更高的系统版本
#define IOS_VERSION_8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)? (YES):(NO))
//判断 iOS 9 或更高的系统版本
#define IOS_VERSION_9_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=9.0)? (YES):(NO))

#if TARGET_OS_IPHONE
//iPhone Device
#endif
#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

typedef NS_ENUM(NSInteger, VCDeviceOrientation) {
    VCDeviceOrientationUnknown,
    VCDeviceOrientationPortrait,            // Device oriented vertically
    VCDeviceOrientationLandscape            // Device oriented horizontally
};

// 程序里的宏定义
#define VERIFTCODE_CAPTCHAID        @"captchaId"
#define VERIFTCODE_DEVICEID         @"deviceId"
#define VERIFTCODE_OS               @"os"
#define VERIFTCODE_OSVER            @"osVer"
#define VERIFTCODE_SDKVER           @"sdkVer"
#define VERIFTCODE_TITLE            @"title"
#define VERIFTCODE_DEBUG            @"debug"
#define VERIFTCODE_WIDTH            @"width"

#define VERIFTCODE_LOCALURL_HEADER  @"file://"

#ifndef __OPTIMIZE__
#define VERIFTCODE_URL              @"http://nctest-captcha.nis.netease.com/v2.x/test/mobile.html"
#else
#define VERIFTCODE_URL              @"https://c.dun.163yun.com/api/v2/mobile.html"
#endif

// 超时的最长时间
#define VERIFTCODE_TIMEOUT          10.0

// 提示信息
#define VERIFTCODE_LOADING          @"拼命加载中..."
#define VERIFTCODE_ERROR_TITLE      @"出现错误"
#define VERIFTCODE_ERROR_TEXT       @"请点击空白处关闭验证视图重试"
#define VERIFTCODE_CAPTCHAID_ERROR_TITLE    @"captchaId错误"
#define VERIFTCODE_CAPTCHAID_ERROR_TEXT     @"请点击空白处关闭并检查captchaId"
#define VERIFTCODE_INVALID_URL      @"url地址不合法,请检查接口调用"

// JS交互
#define VERIFTCODE_JAVASCRIPT_CONTEXT       @"documentView.webView.mainFrame.javaScriptContext"
#define VERIFTCODE_JAVASCRIPT_VALIDATE      @"onValidate"
#define VERIFTCODE_JAVASCRIPT_CLOSE         @"closeWindow"
#define VERIFTCODE_JAVASCRIPT_ONREADY       @"onReady"
#define VERIFTCODE_JAVASCRIPT_ONERROR       @"onError"

#define VERIFTCODE_VALIDATE_SUCCESS         @"true"

#pragma mark app状态
typedef NS_ENUM(NSInteger, APPLIFECYCLESTATUS) {
    DIDENTERBACKGROUD = 1,
    WILLENTERFOREGROUD,
    DIDFINISHLAUNCHING,
    DIDBECOMEACTIVE,
    WILLRESIGNACTIVE,
    WILLTERMINATE
};

#pragma mark 网络状态
typedef enum {
    NTESVerifyCodeNetworkNotReachable = 0,
    NTESVerifyCodeNetworkReachableViaWiFi,
    NTESVerifyCodeNetworkReachableViaWWAN
} NTESVerifyCodeNetworkStatus;

#pragma mark 32bit or 64bit
#ifdef __LP64__
typedef struct mach_header_64 mach_header_t;
typedef struct segment_command_64 segment_command_t;
typedef struct section_64 section_t;
typedef struct nlist_64 nlist_t;
#define LC_SEGMENT_ARCH_DEPENDENT LC_SEGMENT_64
#else
typedef struct mach_header mach_header_t;
typedef struct segment_command segment_command_t;
typedef struct section section_t;
typedef struct nlist nlist_t;
#define LC_SEGMENT_ARCH_DEPENDENT LC_SEGMENT
#endif

#endif
