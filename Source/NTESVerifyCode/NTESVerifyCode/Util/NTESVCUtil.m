//
//  NTESVCUtil.m
//  NTESVerifyCode
//
//  Created by NetEase on 16/12/7.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "NTESVCUtil.h"
#import "NTESVCReachability.h"
#import "NTESVCPrintLog.h"

@implementation NTESVCUtil

+ (NSString*)urlEncode:(NSString*)string {
    
    NSString *result = nil;
    
    if (string && string.length > 0) {
        result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                       (__bridge CFStringRef)string,
                                                                                       NULL,
                                                                                       CFSTR("!*'()^;:@&=+$,/?%#[]"),
                                                                                       kCFStringEncodingUTF8);
    }
    
    return result;
}

+ (BOOL)isNetworkReachable{
    
    NTESVCReachability *internetReach = [NTESVCReachability reachabilityForInternetConnection];
    NTESVCNetworkStatus netStatus = [internetReach currentReachabilityStatus];
    
#ifndef __OPTIMIZE__
    switch (netStatus) {
        case NTESVCNotReachable:
            DDLogDebug(@"Network is not reachable");
            break;
        case NTESVCReachableViaWiFi:
            DDLogDebug(@"Network is WiFi");
            break;
        case NTESVCReachableViaWWAN:
            DDLogDebug(@"Network is WWAN");
            break;
        default:
            break;
    }
#endif
    
    if(netStatus == NTESVCNotReachable) {
        return NO;
    }
    
    return YES;
}

@end
