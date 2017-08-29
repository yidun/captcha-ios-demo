//
//  HalfCircleActivityIndicatorView.m
//  vvim
//
//  Created by admin on 15/9/6.
//  Copyright (c) 2015年 51vv. All rights reserved.
//

#import "NTESVCActivityIndicatorView.h"

@interface NTESVCActivityIndicatorView ()
@property (nonatomic) BOOL isAnimation;
@end

@implementation NTESVCActivityIndicatorView

@synthesize hidesWhenStopped = _hidesWhenStopped;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.hidesWhenStopped = YES;
        self.color = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i = 0; i < 360; i++) {
        CGFloat beginAngle = M_PI * 2 / 360 * i;
        CGFloat toAngle  = beginAngle + M_PI * 2 / 360;
        
        CGFloat alpha = 0;
        if (i < 180) {
            alpha = 1.0 / 180 * (i + 1);
        } else {
            alpha = 1.0 / 180 * (i - 180 + 1);
        }
        [self drawCircleWithContext:context beginAngle:beginAngle toAngle:toAngle color:self.color alpha:alpha];
    }
}

- (void)drawCircleWithContext:(CGContextRef)context beginAngle:(CGFloat)beginAngle toAngle:(CGFloat) toAngle color:(UIColor *)color alpha:(CGFloat)alpha {
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGFloat r, g, b;
    [color getRed:&r green:&g blue:&b alpha:nil];
    CGContextSetRGBStrokeColor(context, r, g, b, alpha);
    CGContextSetLineWidth(context, 2.0);
    CGContextAddArc(context, self.frame.size.width / 2, self.frame.size.height / 2, self.frame.size.width / 2 - 1, beginAngle, toAngle, 0);
    CGContextDrawPath(context, kCGPathStroke);
}

//开始动画，沿着z轴方向旋转
- (void)startAnimating {
    if ([self isAnimating]) {
        return;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = @(0);
    animation.toValue = @(M_PI * 2);
    animation.duration = 1.f;
    animation.repeatCount = INT_MAX;
    
    [self.layer addAnimation:animation forKey:@"rotate"];
    
    _isAnimation = YES;
    self.hidden = NO;
}
//停止动画
- (void)stopAnimating {
    [self.layer removeAnimationForKey:@"rotate"];
    _isAnimation = NO;
    if (_hidesWhenStopped) {
        self.hidden = YES;
    }
}
//动画状态
- (BOOL)isAnimating {
    return _isAnimation;
}

-(void)setHidesWhenStopped:(BOOL)hidesWhenStopped {
    if (_hidesWhenStopped != hidesWhenStopped) {
        _hidesWhenStopped = hidesWhenStopped;
    }
    if (hidesWhenStopped &&
        NO == [self isAnimating]) {
        self.hidden = YES;
    }
    else {
        self.hidden = NO;
    }
}

@end
