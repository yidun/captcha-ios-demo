//
//  NTESVerifyCodeManager.h
//  NTESVerifyCode
//
//  Created by NetEase on 16/11/30.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * @abstract    设置验证码语言类型
 */
typedef NS_ENUM(NSInteger, NTESVerifyCodeLang) {
    // 中文
    NTESVerifyCodeLangCN = 1,
    // 英文
    NTESVerifyCodeLangEN,
    // 繁体
    NTESVerifyCodeLangTW,
    // 日文
    NTESVerifyCodeLangJP,
    // 韩文
    NTESVerifyCodeLangKR,
    // 泰文
    NTESVerifyCodeLangTL,
    // 越南语
    NTESVerifyCodeLangVT,
    // 法语
    NTESVerifyCodeLangFRA,
    // 俄语
    NTESVerifyCodeLangRUS,
    // 阿拉伯语
    NTESVerifyCodeLangKSA,
    // 德语
    NTESVerifyCodeLangDE,
    // 意大利语
    NTESVerifyCodeLangIT,
    // 希伯来语
    NTESVerifyCodeLangHE,
    // 印地语
    NTESVerifyCodeLangHI,
    // 印尼语
    NTESVerifyCodeLangID,
    // 缅甸语
    NTESVerifyCodeLangMY,
    // 老挝语
    NTESVerifyCodeLangLO,
    // 马来语
    NTESVerifyCodeLangMS,
    // 波兰语
    NTESVerifyCodeLangPL,
    // 葡萄牙语
    NTESVerifyCodeLangPT,
    // 西班牙语
    NTESVerifyCodeLangES,
    // 土耳其语
    NTESVerifyCodeLangTR,
};

/**
 * @abstract    设置验证码类型
 */
typedef NS_ENUM(NSInteger, NTESVerifyCodeMode) {
    // 传统验证码
    NTESVerifyCodeNormal = 1,
    // 无感知验证码
    NTESVerifyCodeBind,
};

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
- (void)verifyCodeInitFailed:(NSArray *)error;

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
 * @abstract    delegate,见NTESVerifyCodeManagerDelegate
 */
@property(nonatomic, weak) id<NTESVerifyCodeManagerDelegate>delegate;

/**
 * @abstract    验证码图片显示的frame
 *
 * @说明         验证码控件显示的位置,可以不传递。
 *              (1)如果不传递或者传递为CGRectNull(CGRectZero),则使用默认值:topView的居中显示,宽度为屏幕宽度的4/5,高度:view宽度/2.0 + 65
 *              (2)如果传递,则frame的宽度至少为270;高度至少为:宽度/2.0 + 65.
 */
@property(nonatomic) CGRect            frame;

/**
 * @abstract    验证码图片背景的透明度
 *
 * @说明         范围:0~1，0表示全透明，1表示不透明。默认值:0.3
 */
@property(nonatomic) CGFloat           alpha;

/**
 * @abstract    验证码图片背景的颜色
 *
 * @说明         默认值:黑色
 */
@property(nonatomic) UIColor           *color;

/**
 * @abstract    验证码语言选项
 *
 * @说明         验证码枚举类型NTESVerifyCodeLang，可选范围见枚举定义。
 *              不传默认中文。
 */
@property(nonatomic) NTESVerifyCodeLang    lang;

/**
 * @abstract    验证码滑块icon url，不传则使用易盾默认滑块显示。
 */
@property(nonatomic) NSString *slideIconURL;

/**
 * @abstract    验证码验证成功的滑块icon url，不传则使用易盾默认滑块显示。
 */
@property(nonatomic) NSString *slideIconSuccessURL;

/**
 * @abstract    验证码滑块滑动过程中的icon url，不传则使用易盾默认滑块显示。
 */
@property(nonatomic) NSString *slideIconMovingURL;

/**
 * @abstract    验证码验证失败的滑块icon url，不传则使用易盾默认滑块显示。
 */
@property(nonatomic) NSString *slideIconErrorURL;

/**
 * @abstract    设置验证码类型
 *
 * @说明         验证码枚举类型NTESVerifyCodeMode，可选类型见枚举定义
 *              不传默认传统验证码。
 *
 */
@property(nonatomic) NTESVerifyCodeMode mode;

/**
 * @abstract    设置极端情况下，当验证码服务不可用时，是否开启降级方案。
 *              默认开启，当触发降级开关时，将直接通过验证，进入下一步。
 */
@property(nonatomic) BOOL openFallBack;

/**
 * @abstract    设置发生第fallBackCount次错误时，将触发降级。取值范围 >=1
 *              默认设置为3次，第三次服务器发生错误时，触发降级，直接通过验证。
 */
@property(nonatomic) NSUInteger fallBackCount;

/**
 *  @abstract   初始化方法
 *
 *  @return     返回NTESVerifyCodeManager实例对象
 */
+ (NTESVerifyCodeManager *)getInstance;

/**
 *  @abstract   配置参数
 *
 *  @param      captcha_id      验证码id
 *  @param      timeoutInterval 加载验证码的超时时间,最长12s。这个时间尽量设置长一些，比如7秒以上(7-12s)
 *
 */
- (void)configureVerifyCode:(NSString *)captcha_id
                    timeout:(NSTimeInterval)timeoutInterval;

/**
 *  @abstract   展示验证码视图
 *
 *  @说明        展示位置:[[[UIApplication sharedApplication] delegate] window];全屏居中显示,宽度为屏幕宽度的4/5,高度:view宽度/2.0 + 65.
 */
- (void)openVerifyCodeView;

/**
 *  @abstract   在指定的视图上展示验证码视图
 *
 *  @param      topView         加载验证码控件的父视图,可以为nil。
 *                              (1)如果传递值为nil,则使用默认值:[[[UIApplication sharedApplication] delegate] window]
 *                              (2)如果传递值不为nil，则注意topView的宽高值，宽度至少为270;高度至少为:宽度/2.0 + 65.
 *
 */
- (void)openVerifyCodeView:(UIView *)topView;

/**
 *  @abstract   是否开启sdk日志打印
 *
 *  @param      enabled           YES:开启;NO:不开启
 *
 *  @说明        默认为NO,只打印workflow;设为YES后，Release下只会打印workflow和BGRLogLevelError
 */
- (void)enableLog:(BOOL)enabled;

@end
