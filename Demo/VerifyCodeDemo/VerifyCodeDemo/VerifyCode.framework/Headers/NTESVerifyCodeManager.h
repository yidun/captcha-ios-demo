//
//  NTESVerifyCodeManager.h
//  NTESVerifyCode
//
//  Created by NetEase on 16/11/30.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NTESVerifyCodeManagerDelegate<NSObject>
@optional

/**
 * 验证码组件初始化完成
 */
- (void)verifyCodeInitFinish;

/**
 * 验证码组件初始化出错
 *
 * @param error 错误信息
 */
- (void)verifyCodeInitFailed:(NSString *)error;

/**
 * 完成验证之后的回调
 *
 * @param result 验证结果 BOOL:YES/NO
 * @param validate 二次校验数据，如果验证结果为false，validate返回空
 * @param message 结果描述信息
 *
 */
- (void)verifyCodeValidateFinish:(BOOL)result validate:(NSString *)validate message:(NSString *)message;

/**
 * 关闭验证码窗口后的回调
 */
- (void)verifyCodeCloseWindow;

/**
 * 网络错误
 *
 * @param error 网络错误信息
 */
- (void)verifyCodeNetError:(NSError *)error;

@end


@interface NTESVerifyCodeManager : NSObject

/**
 * delegate,见NTESVerifyCodeManagerDelegate
 */
@property(nonatomic, weak) id<NTESVerifyCodeManagerDelegate>delegate;

/**
 *  @abstract 单例
 *
 *  @return 返回NTESVerifyCodeManager对象
 */
+ (NTESVerifyCodeManager *)sharedInstance;

/**
 *  @abstract 配置参数
 *
 * @param captcha_id 验证码id
 * @param timeoutInterval 展示验证码的超时时间,最长10s。这个时间尽量设置长一些，比如5秒以上(5-10s)
 *
 */
- (void)configureVerifyCode:(NSString *)captcha_id
                    timeout:(NSTimeInterval)timeoutInterval;


/**
 *  @abstract 展示验证码视图
 *
 *  @discussion
 *  实现方式 直接在 keyWindow 上添加遮罩视图、验证码视图
 *
 */
- (void)openVerifyCodeView;

/**
 *  是否开启sdk日志打印
 *
 *  @param enabled YES:开启;NO:不开启
 *
 *  @说明 默认为NO,只打印workflow;设为YES后，Release下只会打印workflow和BGRLogLevelError
 */
- (void)enableLog:(BOOL)enabled;

@end
