//
//  NTESVCVerifyCodeView.h
//  NTESVerifyCode
//
//  Created by NetEase on 16/12/8.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESVCActivityIndicatorView.h"

#ifdef __IPHONE_8_0
#import <WebKit/WebKit.h>
#endif



@protocol NTESVCVerifyCodeViewDelegate<NSObject>
@optional

/**
 * 验证码组件初始化完成
 */
- (void)viewInitFinish;

/**
 * 验证码组件初始化出错
 *
 * @param error 错误信息
 */
- (void)viewInitFailed:(NSString *)error;

/**
 * 完成验证之后的回调
 *
 * @param result 验证结果，类型字符串 "true"/"false"
 * @param validate 二次校验数据，如果验证结果为false，validate返回空
 * @param message 结果描述信息
 *
 */
- (void)viewValidateFinish:(NSString *)result validate:(NSString *)validate message:(NSString *)message;

/**
 * 关闭验证码窗口后的回调
 */
- (void)viewClose;

/**
 * 网络错误
 *
 * @param error 网络错误信息
 */
- (void)viewNetError:(NSError *)error;

@end

@interface NTESVCVerifyCodeView : UIView<UIWebViewDelegate, WKScriptMessageHandler, WKNavigationDelegate, UIScrollViewDelegate>

// 是否有网络
@property(nonatomic, assign)BOOL hasNetwork;

// 超时
@property(nonatomic, assign)BOOL isTimeOut;

// 网络错误回调
@property(nonatomic, assign)BOOL isFailed;
@property(nonatomic, assign)BOOL isFinished;

// 还在显示进度条
@property(nonatomic, assign)BOOL isLoading;

// 定时器
@property(nonatomic, strong)NSTimer *timer;

@property(nonatomic, strong)UIWebView *uiWebView;
@property(nonatomic, strong)WKWebView *wkWebView;

// 是否注册了K-V for contensize of webview
@property(nonatomic, assign)BOOL isRegister;

@property(nonatomic, strong)NTESVCActivityIndicatorView *activityIndicicator;

// 显示loading提示
@property(nonatomic, strong)UILabel *loadingText;

// 显示loading错误标题
@property(nonatomic, strong)UILabel *loadErrorTitle;

// 显示错误提示
@property(nonatomic, strong)UILabel *loadErrorText;

/**
 * delegate,见NTESVCVerifyCodeViewDelegate
 */
@property(nonatomic, weak) id<NTESVCVerifyCodeViewDelegate>delegate;

- (void)startLoad;
- (void)stopLoad;

- (void)layoutCustomViews;

@end
