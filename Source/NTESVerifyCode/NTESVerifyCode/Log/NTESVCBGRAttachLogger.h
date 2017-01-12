//
//  BGRLogger.h
//  Tools
//
//  Created by Monkey on 15/11/25.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESVCBGRLog.h"

@class VCBGRLogMessage;
@class BGRAbstractLogger;



@interface NTESVCBGRAttachLogger : NTESVCBGRAbstractLogger

@property(nonatomic,assign) NSInteger calendarUnitFlags;
@property(nonatomic,retain) NSMutableArray* logArr;
@property(nonatomic,assign) NSInteger logSize;

+(NTESVCBGRAttachLogger*)defaultLogger;

-(void)logMessage:(VCBGRLogMessage *) message;

-(void)addLog:(NSString*) log;

-(NSString*)logs;
- (void) clear;

-(NSString*)loggerName;

@end
