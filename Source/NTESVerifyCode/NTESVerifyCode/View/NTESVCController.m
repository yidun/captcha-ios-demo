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
    });
    
    return sharedObject;
}

- (void)openVCView:(BOOL)animated{
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
    self.topView = [self getTopView];
    if (self.topView) {
        if([self visualEffectEnable]) {
            [self generateVisualView];
            [self.topView addSubview:self.visualEffectView];
        }else{
            [self generateGeneView];
            [self.topView addSubview:self.geneEffectView];
        }
        
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

- (BOOL)visualEffectEnable{
    
    if(IOS_VERSION_8_OR_LATER){
        return YES;
    }
    else{
        return NO;
    }
}

- (CGRect)generateScreenRect{
    // 计算长度大小
    CGFloat dWidth = SCREEN_WIDTH;
    CGFloat dHeight = SCREENH_HEIGHT;
    if (self.deviceOrientation == VCDeviceOrientationLandscape) {
        dWidth = SCREENH_HEIGHT;
        dHeight = SCREEN_WIDTH;
    }
    CGRect rect = CGRectMake(0, 0, dWidth, dHeight);
    
    return rect;
}

- (void)generateVisualView{
    //实现模糊效果
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.visualEffectView.frame = [self generateScreenRect];
    self.visualEffectView.alpha = 1.0;
}

- (void)generateGeneView{
    self.geneEffectView = [[UIView alloc] initWithFrame:[self generateScreenRect]];
    self.geneEffectView.backgroundColor = [UIColor whiteColor];
    self.geneEffectView.alpha = 1.0;
}

- (void)generateBackGroundViewControl{
    self.backGroundViewControl = [[UIControl alloc] initWithFrame:[self generateScreenRect]];
    self.backGroundViewControl.alpha = 1.0;
    [self.backGroundViewControl addTarget:self action:@selector(closeVCViewIfIsOpen) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundViewControl setUserInteractionEnabled:YES];
}

- (void)closeView{
    
    if (self.verifyCodeView) {
        [self.verifyCodeView removeFromSuperview];
    }
    if([self visualEffectEnable]) {
        if (self.visualEffectView) {
            [self.visualEffectView removeFromSuperview];
            self.visualEffectView = nil;
        }
    }else{
        if (self.geneEffectView) {
            [self.geneEffectView removeFromSuperview];
            self.geneEffectView = nil;
        }
    }
    
    if (self.backGroundViewControl) {
        [self.backGroundViewControl removeFromSuperview];
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
    
    // 计算长度大小
    CGFloat dWidth = SCREEN_WIDTH;
    CGFloat dHeight = SCREENH_HEIGHT;
    if (self.deviceOrientation == VCDeviceOrientationLandscape) {
        dWidth = SCREENH_HEIGHT;
        dHeight = SCREEN_WIDTH;
    }
    
    DDLogDebug(@"view screen width:%f, height:%f", dWidth, dHeight);
    
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
    CGRect rect = CGRectMake((dWidth - viewWidth)/2.0, (dHeight - viewHeight) / 2.0, viewWidth, viewHeight);
    
    return rect;
}

- (void)generateVerifyCodeView{
    
    CGRect rec = [self generateFrame];
    DDLogDebug(@"验证码视图尺寸:(%f,%f,%f,%f)", rec.origin.x, rec.origin.y, rec.size.width, rec.size.height);
    self.verifyCodeView = [[NTESVCVerifyCodeView alloc] initWithFrame:rec];
    self.verifyCodeView.delegate = (id<NTESVCVerifyCodeViewDelegate>)[NTESVerifyCodeManager sharedInstance];
}

- (void)layoutCustomViews{
    
    if(self.visualEffectView){
        self.visualEffectView.frame = [self generateScreenRect];
        //DDLogDebug(@"self.visualEffectView.frame:(%f,%f,%f,%f)", self.visualEffectView.frame.origin.x, self.visualEffectView.frame.origin.y, self.visualEffectView.frame.size.width, self.visualEffectView.frame.size.height);
        [self.visualEffectView setNeedsLayout];
    }
    if (self.geneEffectView) {
        self.geneEffectView.frame = [self generateScreenRect];
        //DDLogDebug(@"self.geneEffectView:(%f,%f,%f,%f)", self.geneEffectView.frame.origin.x, self.geneEffectView.frame.origin.y, self.geneEffectView.frame.size.width, self.geneEffectView.frame.size.height);
        [self.geneEffectView setNeedsLayout];
    }
    if (self.backGroundViewControl) {
        self.backGroundViewControl.frame = [self generateScreenRect];
        //DDLogDebug(@"self.backGroundViewControl.frame:(%f,%f,%f,%f)", self.backGroundViewControl.frame.origin.x, self.backGroundViewControl.frame.origin.y, self.backGroundViewControl.frame.size.width, self.backGroundViewControl.frame.size.height);
        [self.backGroundViewControl setNeedsLayout];
    }
    if (self.verifyCodeView) {
        CGRect rec = [self generateFrame];
        DDLogDebug(@"横竖屏切换后验证码视图尺寸:(%f,%f,%f,%f)", rec.origin.x, rec.origin.y, rec.size.width, rec.size.height);
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

