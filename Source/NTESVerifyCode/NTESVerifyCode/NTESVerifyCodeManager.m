//
//  NTESVerifyCodeManager.m
//  NTESVerifyCode
//
//  Created by NetEase on 16/11/30.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import "NTESVerifyCodeManager.h"
#import "./Log/NTESVCPrintLog.h"
#import "./Util/NTESVCDeviceInfo.h"
#import "./Util/NTESVCDefines.h"
#import "./Net/NTESVCNetRequest.h"
#import "./View/NTESVCController.h"


@interface NTESVerifyCodeManager ()<NTESVCVerifyCodeViewDelegate>

@property(nonatomic, strong)NTESVCController *controller;
@property(nonatomic, assign)BOOL isInit;

@end

@implementation NTESVerifyCodeManager

#pragma mark - public property

- (void)setAlpha:(CGFloat)alpha
{
    [NTESVCController sharedInstance].blurEffectAlpha = alpha;
}

- (void)setFrame:(CGRect)frame{
    [NTESVCController sharedInstance].displayFrame = frame;
}

#pragma mark - public method

+ (NTESVerifyCodeManager *)sharedInstance
{
    static dispatch_once_t onceToken = 0;
    static NTESVerifyCodeManager *sharedObject = nil;
    dispatch_once(&onceToken, ^{
        sharedObject = [[NTESVerifyCodeManager alloc] init];
        sharedObject.controller = [NTESVCController sharedInstance];
        sharedObject.controller.delegate = sharedObject;
        sharedObject.isInit = NO;
    });
    
    return sharedObject;
}

- (void)configureVerifyCode:(NSString *)captcha_id
                    timeout:(NSTimeInterval)timeoutInterval{

    if (!captcha_id || captcha_id.length == 0) {
        DDLogError(@"传入的captcha_id无效");
    }
    
    [NTESVCDeviceInfo sharedInstance].baseUrl = [NSURL URLWithString:VERIFTCODE_URL];
    if(timeoutInterval < 0 || timeoutInterval > VERIFTCODE_TIMEOUT){
        [NTESVCDeviceInfo sharedInstance].timeout = VERIFTCODE_TIMEOUT;
    }else{
        [NTESVCDeviceInfo sharedInstance].timeout = timeoutInterval;
    }
    
    [NTESVCDeviceInfo sharedInstance].captchaId = captcha_id;
    self.isInit = YES;
    DDLogWORKFLOW(@"设置参数完成");
}

- (void)openVerifyCodeView{
    
    if (self.controller && self.isInit) {
        [self.controller openVCView:nil];
    }else{
        DDLogWORKFLOW(@"还未初始化相关参数，请检查接口调用");
    }
}

- (void)openVerifyCodeView:(UIView *)topView{
    
    if (self.controller && self.isInit) {
        [self.controller openVCView:topView];
    }else{
        DDLogWORKFLOW(@"还未初始化相关参数，请检查接口调用");
    }
}

/* 设为YES,打印info以上的;设为NO,都不打印
 *
 */
-(void)enableLog:(BOOL)enabled{
    
    //默认只打印workflow
#ifdef __OPTIMIZE__
    if(enabled){
        // 开启后Release下只会打印workflow和BGRLogLevelError
        VCddLogLevel = BGRPrintLevelError;
    }else{
        // 关闭后，只打印workflow
        VCddLogLevel = BGRPrintLevelOff;
    }
#else
    if(enabled){
        // 开启后打印全部
        VCddLogLevel = BGRPrintLevelAll;
    }else{
        // 关闭后，只打印workflow
        VCddLogLevel = BGRPrintLevelOff;
    }
#endif
    
}


#pragma mark - NTESVCVerifyCodeViewDelegate

/**
 * 验证码组件初始化完成
 */
- (void)viewInitFinish{
    if (self.delegate && [self.delegate respondsToSelector:@selector(verifyCodeInitFinish)]) {
        [self.delegate verifyCodeInitFinish];
    }
}

/**
 * 验证码组件初始化出错
 *
 * @param error 错误信息
 */
- (void)viewInitFailed:(NSString *)error{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(verifyCodeInitFailed:)]) {
        [self.delegate verifyCodeInitFailed:error];
    }
}

/**
 * 完成验证之后的回调
 *
 * @param result 验证结果 true/false
 * @param validate 二次校验数据，如果验证结果为false，validate返回空
 * @param message 结果描述信息
 *
 */
- (void)viewValidateFinish:(NSString *)result validate:(NSString *)validate message:(NSString *)message{
    
    BOOL bRet = YES;
    if ([result isEqualToString:VERIFTCODE_VALIDATE_SUCCESS]){
        // 验证成功后，延迟一段时间再关闭。暂时不加
        // sleep(1);
        [[NTESVCController sharedInstance] closeVCViewIfIsOpen];
    }else{
        bRet = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(verifyCodeValidateFinish:validate:message:)]) {
        [self.delegate verifyCodeValidateFinish:bRet validate:validate message:message];
    }
}

/**
 * 关闭验证码窗口后的回调
 */
- (void)viewClose{
    [[NTESVCController sharedInstance] closeVCViewIfIsOpen];
    if (self.delegate && [self.delegate respondsToSelector:@selector(verifyCodeCloseWindow)]) {
        [self.delegate verifyCodeCloseWindow];
    }
}

/**
 * 网络错误
 *
 * @param error 网络错误信息
 */
- (void)viewNetError:(NSError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(verifyCodeNetError:)]) {
        [self.delegate verifyCodeNetError:error];
    }
}

@end
