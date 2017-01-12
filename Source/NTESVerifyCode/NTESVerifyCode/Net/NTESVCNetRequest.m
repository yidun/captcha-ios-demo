//
//  NTESVerifyCodeNetRequest.m
//  VerifyCode
//
//  Created by Monkey on 15/12/23.
//  Copyright © 2015年 NetEase. All rights reserved.
//

#import "NTESVCNetRequest.h"
#import "NTESVCDeviceInfo.h"
#import "NTESVCDefines.h"
#import "NTESVCUtil.h"
#import "NTESVCPrintLog.h"

@implementation NTESVCNetRequest{

}

+ (NSString *)getRequestUrl:(NSString *)baseUrl{
    
    NSMutableString *url = nil;
    
    if (baseUrl && baseUrl.length > 0) {
        
        url = [[NSMutableString alloc] initWithString:baseUrl];
        
        if (![baseUrl hasPrefix:VERIFTCODE_LOCALURL_HEADER]) {
            // 非本地测试地址
            NSString *urlEncodeValue = nil;
            
            NSString *captchaId = [NTESVCDeviceInfo sharedInstance].captchaId;
            [url appendString:@"?"];
            if (captchaId && captchaId.length > 0) {
                urlEncodeValue = [NTESVCUtil urlEncode:captchaId];
                [url appendFormat:@"%@=%@&", VERIFTCODE_CAPTCHAID, urlEncodeValue];
            }
            
            NSString *deviceId = [[NTESVCDeviceInfo sharedInstance] getDeviceId];
            DDLogDebug(@"deviceId:%@", deviceId);
            if (deviceId && deviceId.length > 0) {
                urlEncodeValue = [NTESVCUtil urlEncode:deviceId];
                [url appendFormat:@"%@=%@&", VERIFTCODE_DEVICEID, urlEncodeValue];
            }
            
            NSString *os = [[NTESVCDeviceInfo sharedInstance] getOS];
            if (os && os.length > 0) {
                urlEncodeValue = [NTESVCUtil urlEncode:os];
                [url appendFormat:@"%@=%@&", VERIFTCODE_OS, urlEncodeValue];
            }
            
            NSString *osVer = [[NTESVCDeviceInfo sharedInstance] getOSVer];
            if (osVer && osVer.length > 0) {
                urlEncodeValue = [NTESVCUtil urlEncode:osVer];
                [url appendFormat:@"%@=%@&", VERIFTCODE_OSVER, urlEncodeValue];
            }
            
            NSString *sdkVer = [[NTESVCDeviceInfo sharedInstance] getSDKVer];
            if (sdkVer && sdkVer.length > 0) {
                urlEncodeValue = [NTESVCUtil urlEncode:sdkVer];
                [url appendFormat:@"%@=%@&", VERIFTCODE_SDKVER, urlEncodeValue];
            }
            
            NSString *title = [NTESVCDeviceInfo sharedInstance].title;
            if (title && title.length > 0) {
                urlEncodeValue = [NTESVCUtil urlEncode:title];
                [url appendFormat:@"%@=%@&", VERIFTCODE_TITLE, urlEncodeValue];
            }
            
            /*BOOL debug = [NTESVCDeviceInfo sharedInstance].debug;
             if (debug) {
             [url appendFormat:@"%@=%@&", VERIFTCODE_DEBUG, @"true"];
             }else{
             [url appendFormat:@"%@=%@&", VERIFTCODE_DEBUG, @"false"];
             }*/
            
            NSInteger width = [NTESVCDeviceInfo sharedInstance].width;
            if (width > 0) {
                [url appendFormat:@"%@=%ld&", VERIFTCODE_WIDTH, (long)width];
            }
            
            // 删除最后的一个字符
            if (url && url.length > 0) {
                [url deleteCharactersInRange:NSMakeRange([url length]-1, 1)];
            }
        }
    }
    
    return url;
}

@end
