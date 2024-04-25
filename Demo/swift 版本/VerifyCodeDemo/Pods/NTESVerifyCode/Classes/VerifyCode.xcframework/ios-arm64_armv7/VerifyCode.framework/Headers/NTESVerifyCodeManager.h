//
//  NTESVerifyCodeManager.h
//  NTESVerifyCode
//
//  Created by NetEase on 16/11/30.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NTESVerifyCodeStyleConfig.h"

/**
 * @abstract    设置验证码语言类型
 */
typedef NS_ENUM(NSInteger, NTESVerifyCodeLang) {
    NTESVerifyCodeLangCN = 1, // 中文
    NTESVerifyCodeLangENUS,   // 美式英文
    NTESVerifyCodeLangENGB,   // 英式英文
    NTESVerifyCodeLangTW,     // 台湾繁体
    NTESVerifyCodeLangHK,     // 香港繁体
    NTESVerifyCodeLangJP,     // 日文
    NTESVerifyCodeLangKR,     // 韩文
    NTESVerifyCodeLangTL,     // 泰文
    NTESVerifyCodeLangVT,     // 越南语
    NTESVerifyCodeLangFRA,    // 法语
    NTESVerifyCodeLangRUS,    // 俄语
    NTESVerifyCodeLangKSA,    // 阿拉伯语
    NTESVerifyCodeLangDE,     // 德语
    NTESVerifyCodeLangIT,     // 意大利语
    NTESVerifyCodeLangHE,     // 希伯来语
    NTESVerifyCodeLangHI,     // 印地语
    NTESVerifyCodeLangID,     // 印尼语
    NTESVerifyCodeLangMY,     // 缅甸语
    NTESVerifyCodeLangLO,     // 老挝语
    NTESVerifyCodeLangMS,     // 马来语
    NTESVerifyCodeLangPL,     // 波兰语
    NTESVerifyCodeLangPT,     // 葡萄牙语
    NTESVerifyCodeLangES,     // 西班牙语
    NTESVerifyCodeLangTR,     // 土耳其语
    NTESVerifyCodeLangNL,     // 荷兰语
    NTESVerifyCodeLangUG,     // 维吾尔语
    NTESVerifyCodeLangMN,     // 蒙古语
    NTESVerifyCodeLangMAI,    // 迈蒂利语
    NTESVerifyCodeLangAS,     // 阿萨姆语
    NTESVerifyCodeLangPA,     // 旁遮普语
    NTESVerifyCodeLangOR,     // 欧里亚语
    NTESVerifyCodeLangML,     // 马来亚拉姆语
    NTESVerifyCodeLangKN,     // 卡纳达语
    NTESVerifyCodeLangGU,     // 古吉拉特语
    NTESVerifyCodeLangTA,     // 泰米尔语
    NTESVerifyCodeLangMR,     // 马拉地语
    NTESVerifyCodeLangTE,     // 泰卢固语
    NTESVerifyCodeLangAM,     // 阿姆哈拉语
    NTESVerifyCodeLangMI,     // 毛利语
    NTESVerifyCodeLangSW,     // 斯瓦西里语
    NTESVerifyCodeLangNE,     // 尼泊尔语
    NTESVerifyCodeLangJV,     // 爪哇语
    NTESVerifyCodeLangFIL,    // 菲律宾语
    NTESVerifyCodeLangBN,     // 孟加拉语
    NTESVerifyCodeLangKK,     // 哈萨克语（西里尔文）
    NTESVerifyCodeLangBE,     // 白俄罗斯语
    NTESVerifyCodeLangBO,     // 藏语
    NTESVerifyCodeLangUR,     // 乌尔都语
    NTESVerifyCodeLangSI,     // 僧伽罗语
    NTESVerifyCodeLangKM,     // 高棉语
    NTESVerifyCodeLangUZ,     // 乌兹别克语
    NTESVerifyCodeLangAZ,     // 阿塞拜疆语
    NTESVerifyCodeLangKA,     // 格鲁吉亚语
    NTESVerifyCodeLangEU,     // 巴斯克语
    NTESVerifyCodeLangGL,     // 加利西亚语
    NTESVerifyCodeLangCA,     // 加泰罗尼亚语
    NTESVerifyCodeLangFA,     // 波斯语
    NTESVerifyCodeLangUK,     // 乌克兰语
    NTESVerifyCodeLangHR,     // 克罗地亚语
    NTESVerifyCodeLangSL,     // 斯洛文尼亚语
    NTESVerifyCodeLangLT,     // 立陶宛语
    NTESVerifyCodeLangLV,     // 拉脱维亚语
    NTESVerifyCodeLangET,     // 爱沙尼亚语
    NTESVerifyCodeLangFI,     // 芬兰语
    NTESVerifyCodeLangBG,     // 保加利亚语
    NTESVerifyCodeLangMK,     // 马其顿语
    NTESVerifyCodeLangBS,     // 波斯尼亚语
    NTESVerifyCodeLangSR,     // 塞尔维亚语（拉丁文）
    NTESVerifyCodeLangEL,     // 希腊语
    NTESVerifyCodeLangRO,     // 罗马尼亚语
    NTESVerifyCodeLangSK,     // 斯洛伐克语
    NTESVerifyCodeLangHU,     // 匈牙利语
    NTESVerifyCodeLangCS,     // 捷克语
    NTESVerifyCodeLangDA,     // 丹麦语
    NTESVerifyCodeLangNN,     // 挪威语
    NTESVerifyCodeLangSV,     // 瑞典语
    NTESVerifyCodeLangPTBR,   // 巴西葡语
    NTESVerifyCodeLangESLA,   // 拉美西语
};

/**
 * @abstract    验证码适老
 */
typedef NS_ENUM(NSInteger, NTESVerifyCodeFontSize) {
    // 小号字体
    NTESVerifyCodeFontSizeSmall = 1,
    // 中号字体
    NTESVerifyCodeFontSizeMedium,
    // 大号字体
    NTESVerifyCodeFontSizeLarge,
    // 超大号字体
    NTESVerifyCodeFontSizeXlarge
};

/**
 * @abstract    设置私有化协议类型
 */
typedef NS_ENUM(NSInteger, NTESVerifyCodeProtocol) {
    // https
    NTESVerifyCodeProtocolHttps = 1,
    // http
    NTESVerifyCodeProtocolHttp,
};

/**
* @abstract    验证码关闭的类型
*/
typedef NS_ENUM(NSInteger, NTESVerifyCodeClose) {
    // 手动关闭
    NTESVerifyCodeCloseManual = 1,
    // 验证完毕后自动关闭
    NTESVerifyCodeCloseAuto,
};


typedef NS_ENUM(NSInteger, NTESDeviceOrientation) {
    NTESDeviceOrientationUnknown,
    NTESDeviceOrientationPortrait,            // Device oriented vertically
    NTESDeviceOrientationLandscape            // Device oriented horizontally
};

//
typedef NS_ENUM(NSInteger, NTESUserInterfaceStyle) {
    // 明亮主题
    NTESUserInterfaceStyleLight = 1,
    // 暗黑主题
    NTESUserInterfaceStyleDark
};

@protocol NTESVerifyCodeManagerDelegate
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
- (void)verifyCodeInitFailed:(NSArray *_Nullable)error;

/**
 * 完成验证之后的回调
 *
 * @param result 验证结果 BOOL:YES/NO
 * @param validate 二次校验数据，如果验证结果为false，validate返回空
 * @param message 结果描述信息
 *
 */
- (void)verifyCodeValidateFinish:(BOOL)result validate:(NSString *_Nullable)validate message:(NSString *)message;

/**
 * 关闭验证码窗口后的回调
 *
 * @param close 关闭的类型
 */
- (void)verifyCodeCloseWindow:(NTESVerifyCodeClose)close;

@end


@interface NTESVerifyCodeManager : NSObject

/**
 * @abstract    delegate,见NTESVerifyCodeManagerDelegate
 */
@property(nonatomic, weak) id<NTESVerifyCodeManagerDelegate> _Nullable delegate;

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
 * @abstract    验证码适老化
 *
 * @说明          验证码适老化枚举类型NTESVerifyCodeFontSize，可选范围见枚举定义。
 *              不传默认小号字体。
 */
@property(nonatomic) NTESVerifyCodeFontSize fontSize;

/**
 * @abstract    是否开启哀悼主题
 *
 * @说明         默认值:不开启
 */

@property(nonatomic)BOOL mournTheme;

/**
 * @abstract    明亮暗黑主题
 */

@property(nonatomic)NTESUserInterfaceStyle userInterfaceStyle;

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
 * @abstract    验证码私有化环境配置，业务方可根据需要配置staticServer，不传默认使用易盾服务配置。
 */
@property(nonatomic) NSString *staticServer;

/**
 * @abstract    验证码私有化环境配置，业务方可根据需要配置apiServer，不传默认使用易盾服务配置。
 */
@property(nonatomic) NSString *apiServer;

/**
 * @abstract    验证码私有化环境配置，业务方可根据需要配置协议类型，选项见枚举定义。
 *              不传默认https协议。
 */
@property(nonatomic) NTESVerifyCodeProtocol protocol;

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
 * @abstract   验证码ipv6配置。
 *             默认为 no，传 yes 表示支持ipv6网络。
 */
@property(nonatomic) BOOL ipv6;

/**
 * @abstract   反作弊相关环境配置，业务方可根据需要配置wmConfigServer，不传默认使用易盾服务配置
 *
 */
@property(nonatomic) NSString *wmConfigServer;

/**
 * @abstract   反作弊相关环境配置，业务方可根据需要配置wmApiServer，不传默认使用易盾服务配置
 *
 */
@property(nonatomic) NSString *wmApiServer;

/**
 *  @abstract   反作弊相关环境配置，业务方可根据需要配置wmStaticServer，不传默认使用易盾服务配置
 *
*/
@property(nonatomic) NSString *wmStaticServer;

/**
* @abstract    是否隐藏关闭按钮
*              默认不隐藏，设置为YES隐藏，NO不隐藏
*/
@property(nonatomic) BOOL closeButtonHidden;

/**
 * @abstract    点击背景是否可以关闭验证码视图
 *              默认可以关闭。
 */
@property(nonatomic) BOOL shouldCloseByTouchBackground;

/**
* @abstract  是否显示验证码内的关闭按钮
*              默认不显示，设置为YES显示，NO隐藏
*/
@property(nonatomic) BOOL innerCloseButtonShow;

/**
 extraData透传业务数据
 */
@property (nonatomic) NSString *extraData;

// 设置验证码方向,验证码不会跟随设备旋转而旋转。
@property(nonatomic, assign)NTESDeviceOrientation deviceOrientation;

/** 滑动拼图、智能无感知、短信、语音验证失败后，停留时间。
 如果需要延长错误提示时间（为了让用户感知到）可自定义配置，单位为 ms
 */
@property (nonatomic, assign) NSUInteger refreshInterval;

/**
 * @abstract    验证码私有化环境配置，是否允许采集系统信息,默认为YES采集，设置NO不采集。
 */
@property (nonatomic, assign) BOOL allowUploadSystemInfo;

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
 *  @abstract   配置参数
 *
 *  @param      captcha_id      验证码id
 *  @param      timeoutInterval 加载验证码的超时时间,最长12s。这个时间尽量设置长一些，比如7秒以上(7-12s)
 *  @param      styleConfig 验证码验证码样式配置
 *
 */
- (void)configureVerifyCode:(NSString *)captcha_id
                    timeout:(NSTimeInterval)timeoutInterval
                styleConfig:(NTESVerifyCodeStyleConfig *)styleConfig;

/**
 *  @abstract   自定义loading文案
 *
 *  @param      loadingText  加载中的文案
 *
 */
- (void)configLoadingText:(NSString * _Nullable)loadingText;

/**
 *  @abstract  自定义loading图片， 支持gif、 png 、 jpg等格式。
 *
 *  @说明              自定义 loading图片的参数配置。
 *            (1) 图片格式为 gif 只需要传gifData 即可， animationImage传空。
 *            (2) 图片格式为 png、 jpg时，需要配置animationImage ,gitData传空。
 *
 *  @param      animationImage  单张图片 ，
 *  @param      gifData 图片格式为gif的二进制数据


 */
- (void)configLoadingImage:(UIImage *_Nullable)animationImage
                   gifData:(NSData *_Nullable)gifData;

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
 *                              (2)如果传递值不为nil，则注意topView的宽高值，宽度需为验证码frame宽度加上左右padding:frame.size.width + 16*2;高度至少为验证码framek高度加上上下padding:frame.size.height + 48 + 25

 *
 */
- (void)openVerifyCodeView:(UIView *  _Nullable)topView;

/**
 *  @abstract   在指定的视图上展示验证码视图
 *  @param      topView         加载验证码控件的父视图,可以为nil。
 *  @param      customLoading       自定义加载页，在 verifyCodeInitFinish 组件初始化完成的代理方面里面关闭 ，默认用易盾自带的加载页。
 *  @param      customErrorPage       自定义错误页， 默认用易盾自带的错误页。
 *
 */
- (void)openVerifyCodeView:(UIView *  _Nullable)topView
             customLoading:(BOOL)customLoading
           customErrorPage:(BOOL)customErrorPage;

/**
 *  @abstract   在指定的视图上展示验证码视图
 *  @param      topView         加载验证码控件的父视图,可以为nil。
 *  @param      loadingView        如果是智能无感知验证码，并且是自定义loading页面，loadingView必传。
 *  @param      customLoading       自定义加载页，在 verifyCodeInitFinish 组件初始化完成的代理方面里面关闭 ，默认用易盾自带的加载页。
 *  @param      customErrorPage       自定义错误页， 默认用易盾自带的错误页。
 *
 */
- (void)openVerifyCodeView:(UIView *  _Nullable)topView
               loadingView:(UIView * _Nullable)loadingView
             customLoading:(BOOL)customLoading
           customErrorPage:(BOOL)customErrorPage;

/**
 *  @abstract   关闭验证码视图
 *
 *  @说明       ⚠️ 此方法为主动关闭验证码视图，产品方可按需调用（验证成功和点击关闭按钮SDK会自动关闭验证码视图，并回调verifyCodeCloseWindow方法）
 */
- (void)closeVerifyCodeView;

/**
 *  @abstract   是否开启sdk日志打印
 *
 *  @param      enabled           YES:开启;NO:不开启
 *
 *  @说明        默认为NO,只打印workflow;设为YES后，Release下只会打印workflow和BGRLogLevelError
 */
- (void)enableLog:(BOOL)enabled;


/**
* @abstract    验证码SDK版本号
*/
- (NSString *_Nullable)getSDKVersion;

@end
