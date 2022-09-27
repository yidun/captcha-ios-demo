//
//  NTESVerifyCodeStyleConfig.h
//  NTESVerifyCode
//
//  Created by 罗礼豪 on 2022/6/20.
//  Copyright © 2022 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NTESCapBarTextAlign) {
    NTESCapBarTextAlignLeft = 1,
    NTESCapBarTextAlignRight,
    NTESCapBarTextAlignCenter,
};

@interface NTESVerifyCodeStyleConfig : NSObject

// 验证码圆角
@property (nonatomic, assign) NSUInteger radius;

#pragma mark 验证码标题样式

// 弹框头部标题文字对齐方式，可选值为 left center right
@property (nonatomic, assign) NTESCapBarTextAlign capBarTextAlign;

// 弹框头部下边框颜色，想要去掉的话可取 transparent 或者与背景色同色 #fff
@property (nonatomic, copy) NSString *capBarBorderColor;

// 弹框头部标题文字颜色
@property (nonatomic, copy) NSString *capBarTextColor;

// 弹框头部标题文字字体大小
@property (nonatomic, assign) NSUInteger capBarTextSize;

/**
 弹框头部标题文字字体体重，可设置粗细，
 参考：capBarTextWeight: normal、bold、lighter、bolder、100、200、300、400、500、600、700、800、900
 更多详情参考：https://developer.mozilla.org/en-US/docs/Web/CSS/font-weight
 */
@property (nonatomic, copy) NSString *capBarTextWeight;

// 弹框头部标题所在容器高度
@property (nonatomic, assign) NSUInteger capBarTitleHeight;

// 验证码弹框 body 部分的内边距，相当于总体设置 capPaddingTop，capPaddingRight，capPaddingBottom，capPaddingLeft
@property (nonatomic, assign) NSUInteger capBodyPadding;

#pragma mark 验证码弹框body样式

// 验证码弹框 body 部分的【上】内边距，覆盖 capPadding 对于上内边距的设置,单位px
@property (nonatomic, copy) NSString *capPaddingTop;

// 验证码弹框 body 部分的【右】内边距，覆盖 capPadding 对于右内边距的设置,单位px
@property (nonatomic, copy) NSString *capPaddingRight;

// 验证码弹框 body 部分的【底】内边距，覆盖 capPadding 对于底内边距的设置,单位px
@property (nonatomic, copy) NSString *capPaddingBottom;

// 验证码弹框 body 部分的【左】内边距，覆盖 capPadding 对于左内边距的设置,单位px
@property (nonatomic, copy) NSString *capPaddingLeft;

// 弹框【上】内边距，实践时候可与 capPaddingTop 配合,单位px
@property (nonatomic, copy) NSString *paddingTop;

// 弹框【下】内边距，实践时候可与 capPaddingBottom 配合,单位px
@property (nonatomic, copy) NSString *paddingBottom;

// 验证码弹框body圆角
@property (nonatomic, assign) NSUInteger capBorderRadius;

#pragma mark 验证码滑块样式

// 滑块的边框颜色
@property (nonatomic, copy) NSString *borderColor;

// 滑块的背景颜色
@property (nonatomic, copy) NSString *background;

// 滑块的滑动时边框颜色，滑动类型验证码下有效
@property (nonatomic, copy) NSString *borderColorMoving;

// 滑块的滑动时背景颜色，滑动类型验证码下有效
@property (nonatomic, copy) NSString *backgroundMoving;

// 滑块的成功时边框颜色，此颜色同步了文字成功时文字颜色、滑块背景颜色
@property (nonatomic, copy) NSString *borderColorSuccess;

// 滑块的成功时背景颜色
@property (nonatomic, copy) NSString *backgroundSuccess;

// 滑块的失败时背景颜色
@property (nonatomic, copy) NSString *backgroundError;

// 失败时边框颜色
@property (nonatomic, copy) NSString *borderColorError;

// 滑块的滑块背景颜色
@property (nonatomic, copy) NSString *slideBackground;

// 滑块的内容文本大小
@property (nonatomic, assign) NSUInteger textSize;

// 滑块内容文本颜色（滑块滑动前的颜色，失败、成功前的颜色）
@property (nonatomic, copy) NSString *textColor;

// 滑块的高度
@property (nonatomic, assign) NSUInteger height;

// 滑块的圆角
@property (nonatomic, assign) NSUInteger borderRadius;

// 滑块与验证码视图之间的距离,单位px
@property (nonatomic, copy) NSString *gap;

#pragma mark 验证码右上方刷新按钮和语音按钮组成组件

// 组件圆角大小
@property (nonatomic, assign) NSUInteger executeBorderRadius;

// 组件背景色
@property (nonatomic, copy) NSString *executeBackground;

// 组件外层容器距离组件顶部距离,单位px
@property (nonatomic, copy) NSString *executeTop;

// 组件外层容器距离组件右侧距离,单位px
@property (nonatomic, copy) NSString *executeRight;

@end

NS_ASSUME_NONNULL_END
