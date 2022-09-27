//
//  ViewController.m
//  VerifyCodeDemo
//
//  Created by NetEase on 17/1/3.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+VerfityCodeDemo.h"
#import "Masonry.h"
#import <VerifyCode/NTESVerifyCodeStyleConfig.h>
#import "NTESToastView.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, assign) BOOL isCustomLoadingAndErrorPage;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 8;
    button.backgroundColor = [UIColor blueColor];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(buttonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"加载基础验证码" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(200);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
    
    UIButton *styleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    styleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    styleButton.layer.masksToBounds = YES;
    styleButton.layer.cornerRadius = 8;
    styleButton.backgroundColor = [UIColor blueColor];
    styleButton.titleLabel.textColor = [UIColor whiteColor];
    [styleButton addTarget:self action:@selector(styleButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [styleButton setTitle:@"自定义验证码样式" forState:UIControlStateNormal];
    [self.view addSubview:styleButton];
    [styleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).mas_offset(10);
        make.centerX.equalTo(button);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.titleLabel.font = [UIFont systemFontOfSize:16];
    customButton.layer.masksToBounds = YES;
    customButton.layer.cornerRadius = 8;
    customButton.backgroundColor = [UIColor blueColor];
    customButton.titleLabel.textColor = [UIColor whiteColor];
    [customButton addTarget:self action:@selector(customButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [customButton setTitle:@"自定义加载页和错误页" forState:UIControlStateNormal];
    [self.view addSubview:customButton];
    [customButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(styleButton.mas_bottom).mas_offset(10);
        make.centerX.equalTo(styleButton);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
}

- (void)buttonDidTipped:(UIButton *)sender {
    self.isCustomLoadingAndErrorPage = NO;
    self.manager =  [NTESVerifyCodeManager getInstance];
    if (self.manager) {
        
        // 如果需要了解组件的执行情况,则实现回调
        self.manager.delegate = self;
        
        // captchaid的值是每个产品从后台生成的,比如 @""
        
        // 传统验证码
        NSString *captchaid = @"易盾业务ID";
        self.manager.mode = NTESVerifyCodeNormal;
        [self.manager configureVerifyCode:captchaid timeout:7.0 styleConfig:nil];
        
        // 设置语言
        self.manager.lang = NTESVerifyCodeLangENGB;
        
        // 设置透明度
        self.manager.alpha = 0.3;
        
        self.manager.userInterfaceStyle = NTESUserInterfaceStyleDark;
        
        // 设置颜色
        self.manager.color = [UIColor blackColor];
        
        // 设置frame
        self.manager.frame = CGRectNull;
        self.manager.protocol = NTESVerifyCodeProtocolHttps;
        
        // 是否开启降级方案
        self.manager.openFallBack = YES;
        self.manager.fallBackCount = 3;

        // 是否隐藏关闭按钮
        self.manager.closeButtonHidden = NO;

        // 显示验证码
        [self.manager openVerifyCodeView:nil];
    }
}

- (void)styleButtonDidTipped:(UIButton *)sender {
    self.isCustomLoadingAndErrorPage = NO;
    self.manager =  [NTESVerifyCodeManager getInstance];
    if (self.manager) {
        
        // 如果需要了解组件的执行情况,则实现回调
        self.manager.delegate = self;
        
        // captchaid的值是每个产品从后台生成的,比如 @""
        
        // 传统验证码
        NSString *captchaid = @"请输入易盾业务ID";
        self.manager.mode = NTESVerifyCodeNormal;
        
        // 自定义验证码样式
        NTESVerifyCodeStyleConfig *styleConfig = [[NTESVerifyCodeStyleConfig alloc] init];
        styleConfig.capBarTextAlign = NTESCapBarTextAlignCenter;
        styleConfig.capBarTextColor = @"#25D4D0";
        styleConfig.capBarTextSize = 18;
        styleConfig.capBarTextWeight = @"bold";
        styleConfig.borderColor = @"#25D4D0";
        styleConfig.radius = 10;
        styleConfig.borderRadius = 10;
        styleConfig.backgroundMoving = @"#DC143C";
        styleConfig.executeBorderRadius = 10;
        styleConfig.executeBackground = @"#DC143C";
        [self.manager configureVerifyCode:captchaid timeout:7.0 styleConfig:styleConfig];
        
        // 设置语言
        self.manager.lang = NTESVerifyCodeLangCN;
        
        // 设置透明度
        self.manager.alpha = 0.3;
        
        // 设置颜色
        self.manager.color = [UIColor blackColor];
        
        // 设置frame
        self.manager.frame = CGRectNull;
        self.manager.protocol = NTESVerifyCodeProtocolHttps;
        
        // 是否开启降级方案
        self.manager.openFallBack = YES;
        self.manager.fallBackCount = 3;

        
        // 是否隐藏关闭按钮
        self.manager.closeButtonHidden = NO;

        // 显示验证码
        [self.manager openVerifyCodeView:nil];
    }
}

- (void)customButtonDidTipped:(UIButton *)sender {
    self.isCustomLoadingAndErrorPage = YES;
    self.manager =  [NTESVerifyCodeManager getInstance];
    if (self.manager) {
        
        // 如果需要了解组件的执行情况,则实现回调
        self.manager.delegate = self;
        
        // captchaid的值是每个产品从后台生成的,比如 @""
        
        // 传统验证码
        NSString *captchaid = @"请输入易盾业务ID";
        self.manager.mode = NTESVerifyCodeNormal;
    
        [self.manager configureVerifyCode:captchaid timeout:7.0 styleConfig:nil];
        
        // 设置语言
        self.manager.lang = NTESVerifyCodeLangCN;
        
        // 设置透明度
        self.manager.alpha = 0.3;
        
        // 设置颜色
        self.manager.color = [UIColor blackColor];
        
        // 设置frame
        self.manager.frame = CGRectNull;
        self.manager.protocol = NTESVerifyCodeProtocolHttps;
        
        // 是否开启降级方案
        self.manager.openFallBack = YES;
        self.manager.fallBackCount = 3;

        
        // 是否隐藏关闭按钮
        self.manager.closeButtonHidden = NO;
    
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeVerifyCodeDidTipped)];
        [backgroundView addGestureRecognizer:tap];
        self.backgroundView = backgroundView;
        backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [[UIApplication sharedApplication].keyWindow addSubview:backgroundView];
        
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"face" ofType:@"gif"];
        NSData *imageData = [NSData dataWithContentsOfFile:bundlePath];
        self.loadingImageView = [[UIImageView alloc] init];
        self.loadingImageView.image = [UIImage ntes_animatedGIFWithData:imageData];
        [backgroundView addSubview:_loadingImageView];
        [_loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(backgroundView);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        
        [self.manager openVerifyCodeView:backgroundView customLoading:YES customErrorPage:YES];
    }
}

- (void)closeVerifyCodeDidTipped {
    [self.backgroundView removeFromSuperview];
    [self.manager closeVerifyCodeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NTESVerifyCodeManagerDelegate
/**
 * 验证码组件初始化完成
 */
- (void)verifyCodeInitFinish{
    if (self.isCustomLoadingAndErrorPage) {
        self.loadingImageView.hidden = YES;
    }
   
    NSLog(@"收到初始化完成的回调");
}

/**
 * 验证码组件初始化出错
 *
 * @param error 错误信息
 */
- (void)verifyCodeInitFailed:(NSArray *)error {
    if (self.isCustomLoadingAndErrorPage) {
        self.loadingImageView.hidden = YES;
        [self.backgroundView removeFromSuperview];
        NSString *jsonString = error.firstObject;
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString *name = [dic objectForKey:@"name"];
            [NTESToastView showNotice:name];
        }
    }
   
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
    if (self.isCustomLoadingAndErrorPage) {
        if (result) {
            self.loadingImageView.hidden = YES;
            [self closeVerifyCodeDidTipped];
        }
    }
 
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
