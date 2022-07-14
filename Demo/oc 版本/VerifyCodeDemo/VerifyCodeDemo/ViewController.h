//
//  ViewController.h
//  VerifyCodeDemo
//
//  Created by NetEase on 17/1/3.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VerifyCode/NTESVerifyCodeManager.h>

@interface ViewController : UIViewController<NTESVerifyCodeManagerDelegate>

@property(nonatomic,strong)NTESVerifyCodeManager *manager;

@end

