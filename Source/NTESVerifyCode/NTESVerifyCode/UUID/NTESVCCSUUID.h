//
//  NTESVCCSUUID.h
//  UUID
//
//  Created by NetEase on 16/12/14.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

/*  说明：
    请用混淆后的方式调用：NSString *deviceId = [IVBMhuLApGrpTszy UlHCteTrJOgTlTha];
 */

@interface NTESVCCSUUID : NSObject

/**
 获取设备 ID

 @return 设备 ID
 */
+ (NSString *)getUUID;

@end
