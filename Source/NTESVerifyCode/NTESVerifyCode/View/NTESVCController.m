//
//  NTESVCController.m
//  NTESVerifyCode
//
//  Created by NetEase on 16/12/8.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "NTESVCController.h"
#import "NTESVCPrintLog.h"
#import "NTESVCDeviceInfo.h"
#import "NTESVerifyCodeManager.h"
#import "NTESVCDefines.h"


@implementation NTESVCController

#pragma mark - public method

+ (NTESVCController *)sharedInstance
{
    static dispatch_once_t onceToken = 0;
    static NTESVCController *sharedObject = nil;
    dispatch_once(&onceToken, ^{
        sharedObject = [[NTESVCController alloc] init];
        sharedObject.deviceOrientation = [[NTESVCDeviceInfo sharedInstance] getDeviceOrientation];
        sharedObject.blurEffectAlpha = 0.8;   // 默认0.8
        sharedObject.displayFrame = CGRectZero;
        sharedObject.topView = nil;
    });
    
    return sharedObject;
}

- (void)openVCView:(UIView *)topView{
    
    self.topView = topView;
    
    [self closeVCViewIfIsOpen];
    [self showVCView];
    
    /*
     * 其实绝大部分应用是不支持屏幕旋转的，所以横竖屏切换一般用不到
     */
    // UIApplicationDidChangeStatusBarFrameNotification根据页面内容的旋转来旋转我们的视图，不要根据物理设备旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewOrientChange:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

#pragma mark - private method

- (void)closeVCViewIfIsOpen{
    if(self.isShowingView) {
        
        if(self.verifyCodeView.isLoading) {
            [self.verifyCodeView stopLoad];
        }
        
        [self closeView];
    }
}

- (void)showVCView {
    
    // 没有设置topView,则主动获取
    if (!self.topView) {
        self.topView = [self getTopView];
    }
    
    if (self.topView) {
        
        [self generateGeneView];
        [self.topView addSubview:self.geneEffectView];
        
        [self generateBackGroundViewControl];
        [self.topView addSubview:self.backGroundViewControl];
        
        [self addVCViewOnBackgroundControl];
        [self.verifyCodeView startLoad];
        
        self.isShowingView = YES;

    }else{
        DDLogError(@"没有 topview");
    }
}

- (UIView *)getTopView{
    
    UIView *topView = [[[UIApplication sharedApplication] delegate] window];

    return topView;
}

- (CGRect)generateBackGroundRect{
    
    CGRect rect = CGRectNull;
    
    if (self.topView) {
        rect = CGRectMake(0, 0, self.topView.bounds.size.width, self.topView.bounds.size.height);
    }else{
        // 计算长度大小
        CGFloat dWidth = SCREEN_WIDTH;
        CGFloat dHeight = SCREENH_HEIGHT;
        if (self.deviceOrientation == VCDeviceOrientationLandscape) {
            dWidth = SCREENH_HEIGHT;
            dHeight = SCREEN_WIDTH;
        }
        rect = CGRectMake(0, 0, dWidth, dHeight);
    }
    
    return rect;
}

/*- (void)generateVisualView{
    //实现模糊效果
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.visualEffectView.frame = [self generateBackGroundRect];
    self.visualEffectView.alpha = self.blurEffectAlpha;
}*/

- (void)generateGeneView{
    self.geneEffectView = [[UIView alloc] initWithFrame:[self generateBackGroundRect]];
    self.geneEffectView.backgroundColor = [UIColor whiteColor];
    self.geneEffectView.alpha = self.blurEffectAlpha;
}

- (void)generateBackGroundViewControl{
    self.backGroundViewControl = [[UIControl alloc] initWithFrame:[self generateBackGroundRect]];
    self.backGroundViewControl.alpha = 1.0;
    [self.backGroundViewControl addTarget:self action:@selector(closeVCViewIfIsOpen) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundViewControl setUserInteractionEnabled:YES];
}

- (void)closeView{
    
    if (self.verifyCodeView) {
        [self.verifyCodeView removeFromSuperview];
    }
    
    if (self.backGroundViewControl) {
        [self.backGroundViewControl removeFromSuperview];
    }
    
    if (self.geneEffectView) {
        [self.geneEffectView removeFromSuperview];
        self.geneEffectView = nil;
    }
  
    self.isShowingView = NO;
    
    // 回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewClose)]) {
        [self.delegate viewClose];
    }
}

- (void)addVCViewOnBackgroundControl{
    
    [self generateVerifyCodeView];
    [self.backGroundViewControl addSubview:self.verifyCodeView];
}

- (CGRect)generateFrame{
    CGRect rect = CGRectNull;
    
    CGFloat dWidth = 0;
    CGFloat dHeight= 0;
    if (self.topView) {
        dWidth = self.topView.bounds.size.width;
        dHeight = self.topView.bounds.size.height;
    }else{
        // 计算长度大小
        dWidth = SCREEN_WIDTH;
        dHeight = SCREENH_HEIGHT;
        if (self.deviceOrientation == VCDeviceOrientationLandscape) {
            dWidth = SCREENH_HEIGHT;
            dHeight = SCREEN_WIDTH;
        }
    }
    DDLogDebug(@"verify view screen width:%f, height:%f", dWidth, dHeight);
    
    CGFloat viewWidth = 0.0;
    CGFloat viewHeight = 0.0;
    if(IS_IPHONE){
        CGFloat width = dWidth;
        if (dHeight < dWidth) {
            width = dHeight;
        }
        
        viewWidth = width * 4.0 / 5.0;
        viewHeight = viewWidth * 5 / 9;
    }else{
        CGFloat width = dWidth;
        if (dHeight < dWidth) {
            width = dHeight;
        }
        
        viewWidth = width * 3.0 / 5.0;
        viewHeight = viewWidth * 5 / 9;
    }
    
    [NTESVCDeviceInfo sharedInstance].width = viewWidth;
    
    // webview
    rect = CGRectMake((dWidth - viewWidth)/2.0, (dHeight - viewHeight) / 2.0, viewWidth, viewHeight);
    
    return rect;
}

- (void)generateVerifyCodeView{
    
    // 没有设置位置,则初始化
    if ( CGRectEqualToRect(self.displayFrame, CGRectZero) || CGRectEqualToRect(self.displayFrame, CGRectNull)) {
        self.displayFrame = [self generateFrame];
    }else{
        [NTESVCDeviceInfo sharedInstance].width = self.displayFrame.size.width;
    }
    
    DDLogDebug(@"验证码视图尺寸:(%f,%f,%f,%f)", self.displayFrame.origin.x, self.displayFrame.origin.y, self.displayFrame.size.width, self.displayFrame.size.height);
    self.verifyCodeView = [[NTESVCVerifyCodeView alloc] initWithFrame:self.displayFrame];
    self.verifyCodeView.delegate = (id<NTESVCVerifyCodeViewDelegate>)[NTESVerifyCodeManager sharedInstance];
}

- (void)layoutCustomViews{
    
    if (self.geneEffectView) {
        self.geneEffectView.frame = [self generateBackGroundRect];
        //DDLogDebug(@"self.geneEffectView:(%f,%f,%f,%f)", self.geneEffectView.frame.origin.x, self.geneEffectView.frame.origin.y, self.geneEffectView.frame.size.width, self.geneEffectView.frame.size.height);
        [self.geneEffectView setNeedsLayout];
    }
    if (self.backGroundViewControl) {
        self.backGroundViewControl.frame = [self generateBackGroundRect];
        //DDLogDebug(@"self.backGroundViewControl.frame:(%f,%f,%f,%f)", self.backGroundViewControl.frame.origin.x, self.backGroundViewControl.frame.origin.y, self.backGroundViewControl.frame.size.width, self.backGroundViewControl.frame.size.height);
        [self.backGroundViewControl setNeedsLayout];
    }
    if (self.verifyCodeView) {
        CGRect rec = [self generateFrame];
        //DDLogDebug(@"横竖屏切换后验证码视图尺寸:(%f,%f,%f,%f)", rec.origin.x, rec.origin.y, rec.size.width, rec.size.height);
        [self.verifyCodeView setFrame:rec];
        [self.verifyCodeView layoutCustomViews];
        [self.verifyCodeView setNeedsLayout];
    }
}

- (void)viewOrientChange:(NSNotification *)noti{
    
    VCDeviceOrientation vcOrient = [[NTESVCDeviceInfo sharedInstance] getDeviceOrientation];
    if (vcOrient != self.deviceOrientation) {
        
        DDLogDebug(@"monitor view orient change:(%ld -> %ld)", (long)self.deviceOrientation, (long)vcOrient);
        self.deviceOrientation = vcOrient;
        [self layoutCustomViews];
    }
}

- (void)dealloc{
    DDLogDebug(@"NTESVCController dealloc");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

