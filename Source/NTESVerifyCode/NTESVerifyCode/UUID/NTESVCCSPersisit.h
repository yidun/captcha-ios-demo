//
//  NTESVCCSPersisit.h
//  UUID
//
//  Created by NetEase on 16/12/14.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UUIDPersister NTESVCCSPersisit

#ifdef __OPTIMIZE__
#define NTESVCCSPersisit pnroINpORhOBVafHsrf
#define saveSandBox_CS_UUID JaSgSNTSdFwhtAlW
#define key_CS_UUID aIdyiWXgllBoTgCL
#define getSandBox_CS_UUID hbJGdYvllChvtGZt
#define saveKeyChain_CS_UUID lffXZIPTbvYPiOYT
#define group_CS_UUID wfTUGAdnluiWhlif
#define getKeyChain_CS_UUID VrDlSoFFnDygCuBS
#endif

@interface NTESVCCSPersisit : NSObject

+ (void)saveSandBox_CS_UUID:(NSString *)value key_CS_UUID:(NSString *)key;
+ (NSString *)getSandBox_CS_UUID:(NSString *)key;
+ (void)saveKeyChain_CS_UUID:(NSString *)value key_CS_UUID:(NSString *)key group_CS_UUID:(NSString *)group;
+ (NSString *)getKeyChain_CS_UUID:(NSString *)key group_CS_UUID:(NSString *)group;

@end
