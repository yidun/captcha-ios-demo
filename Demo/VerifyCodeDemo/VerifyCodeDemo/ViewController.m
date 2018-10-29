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
    
    self.manager =  [NTESVerifyCodeManager sharedInstance];
    if (self.manager) {
        
        // 如果需要了解组件的执行情况,则实现回调
        self.manager.delegate = self;
        
        // captchaid的值是每个产品从后台生成的,比如 @"a05f036b70ab447b87cc788af9a60974"
        NSString *captchaid = @"a05f036b70ab447b87cc788af9a60974";
        [self.manager configureVerifyCode:captchaid timeout:10.0];
        
        // 设置语言
        self.manager.lang = NTESVerifyCodeLangCN;
        
        // 设置透明度
        self.manager.alpha = 0.3;
        
        // 设置颜色
        self.manager.color = [UIColor blackColor];
        
        // 设置frame
        self.manager.frame = CGRectNull;
        
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
 * @param message 错误信息
 */
- (void)verifyCodeInitFailed:(NSString *)message{
    NSLog(@"收到初始化失败的回调:%@",message);
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

/**
 * 网络错误
 *
 * @param error 网络错误信息
 */
- (void)verifyCodeNetError:(NSError *)error{
    //用户关闭验证后执行的方法
    NSLog(@"收到网络错误的回调:%@(%ld)", [error localizedDescription], (long)error.code);
}

@end
