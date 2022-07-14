//
//  NTESToastView.m
//  NTESVerifyCodeDemo
//
//  Created by 罗礼豪 on 2020/5/8.
//  Copyright © 2020 NetEase. All rights reserved.
//

#import "NTESToastView.h"
#import <UIKit/UIKit.h>
#import "Masonry.h"

@implementation NTESToastView

+ (void)showNotice:(NSString *)notice {
    
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.8];
    noticeLabel.font = [UIFont systemFontOfSize:12];
    noticeLabel.textColor = [UIColor whiteColor];
    noticeLabel.numberOfLines = 1;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [window addSubview:noticeLabel];
    noticeLabel.text = notice;
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(window);
        make.height.mas_equalTo(30);
    }];
       
    [noticeLabel.layer setMasksToBounds:YES];
    [noticeLabel.layer setCornerRadius:2]; //设置矩形四个圆角半径
       
    noticeLabel.alpha = 0;
    [UIView animateWithDuration:.5f animations:^{
        noticeLabel.alpha = 1;
    } completion:^(BOOL finished) {
        double delayInSeconds = 2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:.5f animations:^{
                noticeLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [noticeLabel removeFromSuperview];
            }];
        });
    }];
}

@end
