//
//  UIImage+VerfityCodeDemo.h
//  NTESVerifyCodeDemo
//
//  Created by 罗礼豪 on 2022/5/17.
//  Copyright © 2022 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (VerfityCodeDemo)

+ (UIImage *)ntes_animatedGIFNamed:(NSString *)name;

+ (UIImage *)ntes_animatedGIFWithData:(NSData *)data;

- (UIImage *)ntes_animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
