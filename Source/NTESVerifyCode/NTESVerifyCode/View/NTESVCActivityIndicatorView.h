//
//  HalfCircleActivityIndicatorView.h
//  vvim
//
//  Created by admin on 15/9/6.
//  Copyright (c) 2015年 51vv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTESVCActivityIndicatorView : UIView

@property (strong, nonatomic) UIColor *color;
@property (nonatomic) BOOL hidesWhenStopped;

- (void)startAnimating;//开始动画
- (void)stopAnimating;//停止动画
- (BOOL)isAnimating;//动画状态

@end
