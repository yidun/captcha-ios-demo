//
//  NTESVCVerifyCodeView.m
//  NTESVerifyCode
//
//  Created by NetEase on 16/12/8.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import "NTESVCVerifyCodeView.h"
#import "NTESVCPrintLog.h"
#import "NTESVCNetRequest.h"
#import "NTESVCDeviceInfo.h"
#import "NTESVCDefines.h"
#import "NTESVCUtil.h"

@interface NTESVCVerifyCodeView ()<WKNavigationDelegate,WKScriptMessageHandler>

@end


@implementation NTESVCVerifyCodeView

/**
 *  初始化视图属性
 *
 *  @param frame 视图frame
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        DDLogDebug(@"NTESVCVerifyCodeView:(%f,%f,%f,%f)", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        
        // 属性初始化
        self.isLoading = NO;
        self.uiWebView = nil;
        self.wkWebView = nil;
        self.isTimeOut = NO;
        self.isFailed = NO;
        self.isFinished = NO;
        self.isRegister = NO;
        
        self.timer = nil;
        
        //定制View
        self.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
        self.alpha = 1;
        
        self.userInteractionEnabled = YES; //设置为NO后，不再响应touch方法
        self.multipleTouchEnabled = YES;
        
        //控制子视图不能超出父视图的范围
        self.clipsToBounds = YES;
        
        //添加子视图
        [self generateSubView];
        
    }
    return self;
}

- (void)startLoad{
    
    // 有网络才去加载
    if(self.hasNetwork){
        // 加载页面
        NSURL *baseUrl = [NTESVCDeviceInfo sharedInstance].baseUrl;
        
        NSString *requestUrl = [NTESVCNetRequest getRequestUrl:baseUrl.absoluteString];
        DDLogDebug(@"url:%@(%f)", requestUrl, [NTESVCDeviceInfo sharedInstance].timeout);
        if (requestUrl && requestUrl.length > 0) {
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]
                                                          cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                      timeoutInterval:[NTESVCDeviceInfo sharedInstance].timeout];
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                [self loadWeb:request];
            });
        }else{
            DDLogError(@"webview请求的地址不合法");
            
            // 没有调用configureVerifyCode方法，而直接调用openVerifyCodeView,产生的错误
            self.isLoading = YES;
            [self updateLoadingErrorView:nil text:VERIFTCODE_INVALID_URL];
        }
    }else{
        DDLogError(@"网络异常，不去加载验证码图片");
        self.isLoading = YES;
        [self updateLoadingErrorView:nil text:nil];
        
        // 回调
        NSError *error = [[NSError alloc] initWithDomain:@"NSURLErrorDomain"
                                                     code:NSURLErrorAppTransportSecurityRequiresSecureConnection
                                                 userInfo:@{NSLocalizedDescriptionKey:@"The Internet connection appears to be offline."}];
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewNetError:)]) {
            [self.delegate viewNetError:error];
        }
    }
}

/**
 *  @abstract 取消异步请求。
 *
 *  @discussion
 *  当希望取消正在执行的Asynchronous Request时，调用此方法取消。
 */
- (void)stopLoad{
    if (self.uiWebView) {
        self.uiWebView.delegate = nil;
        [self.uiWebView stopLoading];
    }else if(self.wkWebView){
        [self.wkWebView stopLoading];
    }
}

#pragma mark - private method

//子视图懒加载
- (void)generateSubView{
    if (!self.uiWebView || !self.wkWebView) {
        // webview
        if(IOS_VERSION_9_OR_LATER)
        {
            [self initWKWebView];
        }else{
            [self initUIWebView];
        }
    }
    
    // 虽然有时显示是有网络的，但是可能代理、认证的原因，仍然会加载失败，需要错误提示
    [self initLoadingErrorView];
    
    // 如果没网络，其实这个用处不大，因为在loadWeb的时候，会判断是否有网络，没网络就直接进入错误提示页面
    self.hasNetwork = [NTESVCUtil isNetworkReachable];
    if (!self.hasNetwork) {
        [self initIndicicatorView];
    }
}

- (void)initWKWebView{
    // webkit内核中的网页视图，类似于UIWebView
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];
    
    [configuration.userContentController addScriptMessageHandler:self name:VERIFTCODE_JAVASCRIPT_VALIDATE];
    [configuration.userContentController addScriptMessageHandler:self name:VERIFTCODE_JAVASCRIPT_CLOSE];
    [configuration.userContentController addScriptMessageHandler:self name:VERIFTCODE_JAVASCRIPT_ONREADY];
    [configuration.userContentController addScriptMessageHandler:self name:VERIFTCODE_JAVASCRIPT_ONERROR];
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    //preferences.minimumFontSize = 40.0;
    configuration.preferences = preferences;
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1) configuration:configuration];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.backgroundColor = [UIColor clearColor];
    self.wkWebView.alpha = 0.0;
    [self addSubview:self.wkWebView];
}

- (void)initUIWebView{
    self.uiWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    self.uiWebView.delegate = self;
    self.uiWebView.backgroundColor = [UIColor clearColor];
    self.uiWebView.alpha = 0.0;
    [self addSubview:self.uiWebView];
    //取消右侧，下侧滚动条，去处上下滚动边界的黑色背景
    for (UIView *_aView in [self.uiWebView subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
            //右侧的滚动条
            
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
            //下侧的滚动条
            
            for (UIView *_inScrollview in _aView.subviews)
            {
                if ([_inScrollview isKindOfClass:[UIImageView class]])
                {
                    _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                }
            }
        }
    }
}

- (void)initIndicicatorView{
    
    // 添加转圈的等待图
    NSInteger width = self.frame.size.width / 6.0;
    NSInteger height = width;
    float indicicatorX = self.frame.size.width / 2.0 - width / 2.0;
    float indicicatorY = self.frame.size.height /2.0 - height /2.0;
    indicicatorY = indicicatorY * 3 / 5;
    self.activityIndicicator = [[NTESVCActivityIndicatorView alloc] initWithFrame: CGRectMake(indicicatorX, indicicatorY, width , height)];
    
    DDLogDebug(@"NTESVCActivityIndicatorView:(%f,%f,%f,%f)", self.activityIndicicator.frame.origin.x, self.activityIndicicator.frame.origin.y, self.activityIndicicator.frame.size.width, self.activityIndicicator.frame.size.height);
    
    [self addSubview:self.activityIndicicator];
    [self showWaitingDialog];
    
    // loading提示
    float labelWidth = self.frame.size.width;
    float labelHeight = 40;
    float labelX = 0;
    float labelY = indicicatorY + height + 15;
    self.loadingText = [[UILabel alloc] initWithFrame: CGRectMake(labelX, labelY, labelWidth , labelHeight)];
    self.loadingText.text = VERIFTCODE_LOADING;
    self.loadingText.textColor = [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0];
    self.loadingText.textAlignment = NSTextAlignmentCenter;
    self.loadingText.adjustsFontSizeToFitWidth = YES;
    self.loadingText.font = [UIFont fontWithName:@"Helvetica" size:22];
    self.loadingText.backgroundColor = [UIColor clearColor];
    [self addSubview:self.loadingText];
}

- (void)initLoadingErrorView{
    // loading错误标题
    float labelErrorX = 0;
    float labelErrorWidth = self.frame.size.width;
    float labelErrorHeight = 40;
    float labelErrorY = self.frame.size.height /4.0 ;
    
    self.loadErrorTitle = [[UILabel alloc] initWithFrame: CGRectMake(labelErrorX, labelErrorY, labelErrorWidth , labelErrorHeight)];
    self.loadErrorTitle.text = VERIFTCODE_ERROR_TITLE;
    self.loadErrorTitle.textColor = [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0];
    self.loadErrorTitle.textAlignment = NSTextAlignmentCenter;
    self.loadErrorTitle.adjustsFontSizeToFitWidth = YES;
    self.loadErrorTitle.alpha = 0.0;
    self.loadErrorTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    self.loadErrorTitle.backgroundColor = [UIColor clearColor];
    [self addSubview:self.loadErrorTitle];
    
    // loading错误内容
    float labelErrorTextX = 0;
    float labelErrorTextWidth = self.frame.size.width;
    float labelErrorTextHeight = 40;
    float labelErrorTextY = labelErrorY + labelErrorHeight + 10;
    
    self.loadErrorText = [[UILabel alloc] initWithFrame: CGRectMake(labelErrorTextX, labelErrorTextY, labelErrorTextWidth , labelErrorTextHeight)];
    self.loadErrorText.text = VERIFTCODE_ERROR_TEXT;
    self.loadErrorText.textColor = [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0];
    self.loadErrorText.textAlignment = NSTextAlignmentCenter;
    self.loadErrorText.adjustsFontSizeToFitWidth = YES;
    self.loadErrorText.alpha = 0.0;
    self.loadErrorText.font = [UIFont fontWithName:@"Helvetica" size:16];
    self.loadErrorText.backgroundColor = [UIColor clearColor];
    [self addSubview:self.loadErrorText];
}

- (void)layoutCustomViews{
    
    NSInteger width = self.frame.size.width / 6.0;
    NSInteger height = width;
    float indicicatorY = self.frame.size.height /2.0 - height /2.0;
    indicicatorY = indicicatorY * 3 / 5;
    
    float labelY = indicicatorY + height + 15;
    if (!self.loadingText) {
        float labelWidth = self.frame.size.width;
        float labelHeight = 40;
        float labelX = 0;
        float labelY = indicicatorY + height + 15;
        [self.loadingText setFrame:CGRectMake(labelX, labelY, labelWidth , labelHeight)];
    }
    
    if (self.loadErrorTitle) {
        float labelErrorX = 0;
        float labelErrorY = labelY - 40;
        float labelErrorWidth = self.frame.size.width;
        float labelErrorHeight = 40;
        [self.loadErrorTitle setFrame:CGRectMake(labelErrorX, labelErrorY, labelErrorWidth , labelErrorHeight)];
    }
}

- (void)loadWeb:(NSURLRequest* )url{

    DDLogWORKFLOW(@"加载视图");
    if(IOS_VERSION_9_OR_LATER){
        [self.wkWebView loadRequest:url];
        [self.wkWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld context:nil];
        self.isRegister =  YES;
        
    }else{
        [self.uiWebView loadRequest:url];
        [self.uiWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld context:nil];
        self.isRegister =  YES;
    }
    
    /* 自定义网络连接超时处理
     * NSURLRequest的超时参数在WKWebview中有效，可能会比设定值多2秒
     * NSURLRequest的超时参数在UIWebview中基本无效，设置5s，一直到30s都不返回超时错误
     * 所以加了定时器，超时时间比webview的超时多1s
     */
    self.isTimeOut = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:[NTESVCDeviceInfo sharedInstance].timeout + 1 target:self selector:@selector(performStopLoading) userInfo:nil repeats:NO];
  
}
- (void)performStopLoading{

    DDLogDebug(@"执行超时定时器");
    if (!self.isFinished) {
        self.isTimeOut = YES;
        if(IOS_VERSION_9_OR_LATER){
            [self.wkWebView stopLoading];
        }else{
            [self.uiWebView stopLoading];
        }
    }
    
    // 回调
    NSError *error = [[NSError alloc] initWithDomain:@"NSURLErrorDomain"
                                                code:NSURLErrorTimedOut
                                            userInfo:@{NSLocalizedDescriptionKey:@"The request timed out."}];
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewNetError:)]) {
        [self.delegate viewNetError:error];
    }
}

- (void)showWaitingDialog{
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        if (self.activityIndicicator) {
            [self.activityIndicicator startAnimating];
        }
        self.isLoading = YES;
    });
}

- (void)hideWaitingDialog{
    dispatch_async(dispatch_get_main_queue(), ^(){
        if (self.activityIndicicator) {
            [self.activityIndicicator stopAnimating];
        }
    });
}

- (void)updateFinishView{
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        if (self.isLoading) {
            self.isLoading = NO;
            [self hideWaitingDialog];
        }
        self.loadingText.alpha = 0.0;
        self.backgroundColor = [UIColor clearColor];
    }completion:^(BOOL finish){
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // 如果有失败消息,则不显示webview
            if(!self.isFailed){
                if(IOS_VERSION_9_OR_LATER){
                    self.wkWebView.alpha = 1.0;
                    DDLogInfo(@"updateFinishView wkWebView.alpha = 1.0");
                }else{
                    self.uiWebView.alpha = 1.0;
                }
            }
        }completion:^(BOOL finish){
            // 显示结束后，如果有失败消息,则隐藏webview
            if (self.isFailed) {
                DDLogInfo(@"updateFinishView completion wkWebView.alpha = 0.0");
                [self updateLoadingErrorView:nil text:nil];
            }
        }];
    }];

}

- (void)updateLoadingErrorView:(NSString *)title text:(NSString *)text{
    
    if (self.isLoading) {
        self.isLoading = NO;
        [self hideWaitingDialog];
        self.loadingText.alpha = 0.0;
    }
    
    DDLogInfo(@"updateLoadingErrorView");
    
    // 当capthchaid错误，会收到onReady，webview的finish消息，然后才是onError
    // 如果收到过finish消息，则需要把webview隐藏
    if(IOS_VERSION_9_OR_LATER){
        if (self.wkWebView.alpha == 1.0) {
            self.wkWebView.alpha = 0.0;
            DDLogInfo(@"updateLoadingErrorView wkWebView.alpha = 0.0");
        }
    }else{
        if (self.uiWebView.alpha == 1.0) {
            self.uiWebView.alpha = 0.0;
        }
    }
    
    self.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    self.loadErrorTitle.alpha = 1.0;
    if (title && title.length > 0) {
        self.loadErrorTitle.text = title;
    }else{
        self.loadErrorTitle.text = VERIFTCODE_ERROR_TITLE;
    }
    
    self.loadErrorText.alpha = 1.0;
    if (text && text.length > 0) {
        self.loadErrorText.text = text;
    }else{
        self.loadErrorText.text = VERIFTCODE_ERROR_TEXT;
    }
}

- (void)handleUIWebViewJSEvent{
    if (self.uiWebView) {
        JSContext *context = [self.uiWebView valueForKeyPath:VERIFTCODE_JAVASCRIPT_CONTEXT];
        if (context) {
            //定义好JS要调用的方法, onValidate就是调用的onValidate方法名
            context[VERIFTCODE_JAVASCRIPT_VALIDATE] = ^() {
                DDLogInfo(@"recevie validate callback(UIWebView)");
                NSArray *args = [JSContext currentArguments];
                
                if (args.count == 3) {
                    JSValue *jsVal;
                    
                    jsVal = [args objectAtIndex:0];
                    NSString *result = jsVal.toString;
                    
                    jsVal = [args objectAtIndex:1];
                    NSString *validate = jsVal.toString;
                    
                    jsVal = [args objectAtIndex:2];
                    NSString *message = jsVal.toString;
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(viewValidateFinish:validate:message:)]) {
                        [self.delegate viewValidateFinish:result validate:validate message:message];
                    }
                }else{
                    DDLogError(@"服务器返回验证结果时，参数个数有误");
                }
            };
            
            context[VERIFTCODE_JAVASCRIPT_CLOSE] = ^() {
                DDLogInfo(@"recevie close window callback(UIWebView)");
                
                // 回调
                if (self.delegate && [self.delegate respondsToSelector:@selector(viewClose)]) {
                    [self.delegate viewClose];
                }
            };
            
            context[VERIFTCODE_JAVASCRIPT_ONREADY] = ^() {
                DDLogInfo(@"recevie onReady callback(UIWebView)");
                // 回调
                if (self.delegate && [self.delegate respondsToSelector:@selector(viewInitFinish)]) {
                    [self.delegate viewInitFinish];
                }
            };
            
            context[VERIFTCODE_JAVASCRIPT_ONERROR] = ^() {
                DDLogInfo(@"recevie onError callback(UIWebView)");
                
                NSArray *args = [JSContext currentArguments];
                
                if (args.count == 1) {
                    JSValue *jsVal;
                    
                    jsVal = [args objectAtIndex:0];
                    NSString *error = jsVal.toString;
                    
                    // 回调
                    if (self.delegate && [self.delegate respondsToSelector:@selector(viewInitFailed:)]) {
                        [self.delegate viewInitFailed:error];
                    }
                }else{
                    DDLogError(@"服务器返回初始化错误结果时，的参数个数不正确");
                }
                
                self.isFailed = YES;
                
                // 在网络很差的情况下: "开发者" -> "Very Bad Network",可能会出现先收到"didFailNavigation"错误，然后收到 "onError callback"
                [self updateLoadingErrorView:VERIFTCODE_CAPTCHAID_ERROR_TITLE text:VERIFTCODE_CAPTCHAID_ERROR_TEXT];
            };
        }
    }
}

- (void)handleWKWebViewJSEvent:(WKScriptMessage *)message{
    
    if (message.name && message.body) {
        if([message.name isEqualToString:VERIFTCODE_JAVASCRIPT_VALIDATE]) {
            DDLogInfo(@"recevie validate callback(WKWebView)");
            if([message.body isKindOfClass:[NSArray class]]) {
                NSArray *bodyArr = (NSArray *)message.body;
                if (bodyArr.count == 3) {
                    NSString *result = [message.body objectAtIndex:0];
                    NSString *validate = [message.body objectAtIndex:1];
                    NSString *msg = [message.body objectAtIndex:2];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(viewValidateFinish:validate:message:)]) {
                        [self.delegate viewValidateFinish:result validate:validate message:msg];
                    }
                }else{
                    DDLogError(@"服务器返回验证结果时，参数个数有误");
                }
            }
        }else if([message.name isEqualToString:VERIFTCODE_JAVASCRIPT_CLOSE]) {
            DDLogInfo(@"recevie close window callback(WKWebView)");
            if (self.delegate && [self.delegate respondsToSelector:@selector(viewClose)]) {
                [self.delegate viewClose];
            }
        } else if ([message.name isEqualToString:VERIFTCODE_JAVASCRIPT_ONREADY]) {
            DDLogInfo(@"recevie onReady callback(WKWebView)");
            if (self.delegate && [self.delegate respondsToSelector:@selector(viewInitFinish)]) {
                [self.delegate viewInitFinish];
            }
        } else if ([message.name isEqualToString:VERIFTCODE_JAVASCRIPT_ONERROR]) {
            DDLogInfo(@"recevie onError callback(WKWebView)");
            
            if([message.body isKindOfClass:[NSString class]]) {
                NSString *error = message.body;
                if (self.delegate && [self.delegate respondsToSelector:@selector(viewInitFailed:)]) {
                    [self.delegate viewInitFailed:error];
                }
            }
            
            self.isFailed = YES;
            
            // 在网络很差的情况下: "开发者" -> "Very Bad Network",可能会出现先收到"didFailNavigation"错误，然后收到 "onError callback"
            [self updateLoadingErrorView:VERIFTCODE_CAPTCHAID_ERROR_TITLE text:VERIFTCODE_CAPTCHAID_ERROR_TEXT];
        }
    }
}



#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    DDLogInfo(@"didStartProvisionalNavigation");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    DDLogInfo(@"didCommitNavigation");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    DDLogInfo(@"didFinishNavigation");
  
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (!self.isFailed) {
        // 一个http请求，可能会收到多次的didFinishNavigation
        if(!self.isFinished){
            [self updateFinishView];
        }
        self.isFinished = YES;        

    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    DDLogInfo(@"didFailProvisionalNavigation");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.isFailed = YES;
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
    [self updateLoadingErrorView:nil text:nil];

    // 回调, code == NSURLErrorCancelled时，表示是用户取消了网络请求；SDK会在超时后，取消请求，然后会回调给APP
    if (error && error.code != NSURLErrorCancelled) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewNetError:)]) {
            [self.delegate viewNetError:error];
        }
    }
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    DDLogInfo(@"didFailNavigation");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.isFailed = YES;
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
    [self updateLoadingErrorView:nil text:nil];
    
    // 回调, code == NSURLErrorCancelled时，表示是用户取消了网络请求；SDK会在超时后，取消请求，然后会回调给APP
    if (error && error.code != NSURLErrorCancelled) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewNetError:)]) {
            [self.delegate viewNetError:error];
        }
    }

}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    DDLogInfo(@"didReceiveServerRedirectForProvisionalNavigation");
}


#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
}

//web端同JavaScript发送的消息会在次代理中处理
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    DDLogDebug(@"WKWebView Receive ScriptMessage");
    if (message) {
        if (message.name && message.body) {
            [self handleWKWebViewJSEvent:message];
        }else{
            DDLogError(@"WKWebView Receive ScriptMessage,but message.name or message.body is nil");
        }
       
    }else{
        DDLogError(@"WKWebView Receive ScriptMessage,but message is nil");
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    DDLogInfo(@"shouldStartLoadWithRequest");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    DDLogInfo(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DDLogInfo(@"webViewDidFinishLoad");
    
    //修改服务器页面的meta的值
    /*NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];*/
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (!self.isFailed) {
        self.isFinished = YES;
        
        [self updateFinishView];
        [self handleUIWebViewJSEvent];
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DDLogInfo(@"didFailLoadWithError");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.isFailed = YES;
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
    [self updateLoadingErrorView:nil text:nil];
    
    // 回调, code == NSURLErrorCancelled时，表示是用户取消了网络请求；SDK会在超时后，取消请求，然后会回调给APP
    if (error && error.code != NSURLErrorCancelled) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewNetError:)]) {
            [self.delegate viewNetError:error];
        }
    }
}

#pragma mark - K-V for contensize of webview

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        float webViewHeight = 0;
        CGRect newFrame;
        if (self.uiWebView) {
            newFrame = self.uiWebView.frame;
            webViewHeight = self.uiWebView.scrollView.contentSize.height;
            //DDLogInfo(@"observeValueForKeyPath,height:%f", webViewHeight);
            newFrame.size.height  = webViewHeight;
            //DDLogInfo(@"observeValueForKeyPath,frame:(%f, %f, %f, %f)", newFrame.origin.x, newFrame.origin.y, newFrame.size.width, newFrame.size.height);
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.uiWebView.frame = newFrame;
            }completion:^(BOOL finish){
                
            }];
        }else{
            newFrame = self.wkWebView.frame;
            webViewHeight = self.wkWebView.scrollView.contentSize.height;
            //DDLogInfo(@"observeValueForKeyPath,height:%f", webViewHeight);
            newFrame.size.height  = webViewHeight;
            //DDLogInfo(@"observeValueForKeyPath,frame:(%f, %f, %f, %f)", newFrame.origin.x, newFrame.origin.y, newFrame.size.width, newFrame.size.height);
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.wkWebView.frame = newFrame;
            }completion:^(BOOL finish){
                
            }];
        }
    }
}

- (void)dealloc{
    DDLogDebug(@"NTESVerifyCodeView dealloc");
    if (self.isRegister) {
        DDLogDebug(@"delete K-V for contensize of webview");
        if(IOS_VERSION_9_OR_LATER){
            [self.wkWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
            
        }else{
            [self.uiWebView.scrollView removeObserver: self forKeyPath:@"contentSize"];
        }
    }
    
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
