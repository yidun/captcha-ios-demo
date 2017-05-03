//
//  NTESVCController.h
//  NTESVerifyCode
//
//  Created by NetEase on 16/12/8.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NTESVCVerifyCodeView.h"
#import "NTESVCDefines.h"

@interface NTESVCController : NSObject

@property(nonatomic, assign)BOOL isShowingView;

// 设备方向
@property(nonatomic, assign)VCDeviceOrientation deviceOrientation;

// 显示的视图以及位置
@property(nonatomic, strong)UIView *topView;
@property(nonatomic, assign)CGRect displayFrame;

@property(nonatomic, strong)UIView *geneEffectView;

@property(nonatomic, strong)UIControl *backGroundViewControl;
@property(nonatomic, strong)NTESVCVerifyCodeView *verifyCodeView;

@property(nonatomic, assign)CGFloat blurEffectAlpha;

/**
 * delegate,见NTESVCVerifyCodeViewDelegate
 */
@property(nonatomic, weak) id<NTESVCVerifyCodeViewDelegate>delegate;

/**
 *  单例
 *
 *  @return 返回NTESVCController对象
 */
+ (NTESVCController *)sharedInstance;

- (void)closeVCViewIfIsOpen;

- (void)openVCView:(UIView *)topView;

@end
