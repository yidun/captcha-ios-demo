//
//  SceneDelegate.h
//  NTESLiveDetectPublicDemo
//
//  Created by Ke Xu on 2019/10/10.
//  Copyright © 2019 Ke Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AppEnterBackground)(void);

@interface SceneDelegate : UIResponder <UIWindowSceneDelegate>

@property (copy, nonatomic) AppEnterBackground enterBackground;

@property (strong, nonatomic) UIWindow * window;

@end

