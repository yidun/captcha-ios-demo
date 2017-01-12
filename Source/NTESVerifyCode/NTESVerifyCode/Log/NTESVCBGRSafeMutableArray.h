//
//  BGRSafeMutableArray.h
//  Tools
//
//  Created by Monkey on 15/11/25.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTESVCBGRSafeMutableArray : NSMutableArray

@property(nonatomic,retain) NSRecursiveLock* safeLock;
@property(nonatomic,assign) CFMutableArrayRef array;

- (id)initWithCapacity:(NSUInteger) numItems;

- (NSUInteger)count;

- (id)objectAtIndex:(CFIndex) index;

- (void)addObject:(id) object;

- (void)insertObject:(id) object atIndex:(CFIndex) index;

- (void)removeLastObject;

- (void)removeObjectAtIndex:(CFIndex) index;

- (void)replaceArrayAtIndex:(CFIndex) index withObject:(id) object;

- (id)firstObject;

- (id)lastObject;

- (void)removeAllObjects;

- (void)removeObjectsInRange:(NSRange) range;

- (CFIndex)indexOfObject:(id) object;

- (void)removeFirstObject;

- (void)lock;

- (void)unlock;

@end
