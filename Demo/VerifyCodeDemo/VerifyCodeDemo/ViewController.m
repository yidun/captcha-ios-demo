//
//  ViewController.m
//  VerifyCodeDemo
//
//  Created by NetEase on 17/1/3.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)openView:(id)sender {
    self.manager =  [NTESVerifyCodeManager getInstance];
    if (self.manager) {
        
        // 如果需要了解组件的执行情况,则实现回调
        self.manager.delegate = self;
        
        // captchaid的值是每个产品从后台生成的,比如 @""
        
        // 传统验证码
        NSString *captchaid = @"请输入易盾业务ID";
        self.manager.mode = NTESVerifyCodeNormal;
        
        [self.manager configureVerifyCode:captchaid timeout:7.0];
        
        // 设置语言
        self.manager.lang = NTESVerifyCodeLangCN;
        
        // 设置透明度
        self.manager.alpha = 0.3;
        
        // 设置颜色
        self.manager.color = [UIColor blackColor];
        self.manager.fontSize = NTESVerifyCodeFontSizeLarge;
        
        // 设置frame
        self.manager.frame = CGRectNull;
        self.manager.protocol = NTESVerifyCodeProtocolHttps;
        
        // 是否开启降级方案
        self.manager.openFallBack = YES;
        self.manager.fallBackCount = 3;

        // 是否隐藏关闭按钮
        self.manager.closeButtonHidden = NO;
        NSString  *version = [self.manager getSDKVersion];
        
//        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"face" ofType:@"gif"];
//        NSData *imageData = [NSData dataWithContentsOfFile:bundlePath];
//        [self.manager configLoadingImage:nil gifData:imageData];
//        [self.manager configLoadingText:@"1111"];
        
        // 显示验证码
        [self.manager openVerifyCodeView:nil];
    }    
}

#pragma mark - NTESVerifyCodeManagerDelegate
/**
 * 验证码组件初始化完成
 */
- (void)verifyCodeInitFinish{
    NSLog(@"收到初始化完成的回调");
}

/**
 * 验证码组件初始化出错
 *
 * @param error 错误信息
 */
- (void)verifyCodeInitFailed:(NSArray *)error {
//    NSLog(@"收到初始化失败的回调:%@",error);
}
/**
 * 完成验证之后的回调
 *
 * @param result 验证结果 BOOL:YES/NO
 * @param validate 二次校验数据，如果验证结果为false，validate返回空
 * @param message 结果描述信息
 *
 */
- (void)verifyCodeValidateFinish:(BOOL)result validate:(NSString *)validate message:(NSString *)message{
    NSLog(@"收到验证结果的回调:(%d,%@,%@)", result, validate, message);
}

/**
 * 关闭验证码窗口后的回调
 */
- (void)verifyCodeCloseWindow{
    //用户关闭验证后执行的方法
    NSLog(@"收到关闭验证码视图的回调");
}

- (void)verifyCodeCloseWindow:(NTESVerifyCodeClose)close {
    
}

@end
