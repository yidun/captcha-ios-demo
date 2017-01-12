//
//  BGRSafeMutableArray.m
//  Tools
//
//  Created by Monkey on 15/11/25.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "NTESVCBGRSafeMutableArray.h"

@implementation NTESVCBGRSafeMutableArray

- (instancetype)init
{
    self = [super init];
    if (self) {
        _safeLock = [[NSRecursiveLock alloc] init];
        _array = CFArrayCreateMutable(kCFAllocatorDefault, 0, &kCFTypeArrayCallBacks);
    }
    return self;
}

-(id)initWithCapacity:(NSUInteger)numItems{
    self = [super init];
    if (self) {
        _safeLock = [[NSRecursiveLock alloc] init];
        _array = CFArrayCreateMutable(kCFAllocatorDefault, numItems, &kCFTypeArrayCallBacks);
    }
    return self;
}

-(NSUInteger)count{
    NSUInteger index;
    [_safeLock lock];
    index = CFArrayGetCount(_array);
    [_safeLock unlock];
    return index;
}

-(id)objectAtIndex:(CFIndex) index{
    id retVal = nil;
    [_safeLock lock];
    if(CFArrayGetCount(_array) <= index)
        retVal = nil;
    else
        retVal = CFArrayGetValueAtIndex(_array, index);
    [_safeLock unlock];
    
    return retVal;
}

-(void)addObject:(id) object{
    if(object){
        [_safeLock lock];
        CFArrayAppendValue(_array, (__bridge const void *)(object));
        [_safeLock unlock];
    }
}

-(void)insertObject:(id) object atIndex:(CFIndex) index{
    if(object){
        [_safeLock lock];
        if(CFArrayGetCount(_array) < index){
            index = CFArrayGetCount(_array);
        }
        CFArrayInsertValueAtIndex(_array, index, (__bridge const void *)(object));
        [_safeLock unlock];
    }
}

-(void)removeLastObject{
    [_safeLock lock];
    if(CFArrayGetCount(_array)){
        CFArrayRemoveValueAtIndex(_array, CFArrayGetCount(_array)-1);
    }
    [_safeLock unlock];

}

-(void)removeObjectAtIndex:(CFIndex) index{
    [_safeLock lock];
    if(CFArrayGetCount(_array) > index){
        CFArrayRemoveValueAtIndex(_array, index);
    }
    [_safeLock unlock];
}

-(void)replaceArrayAtIndex:(CFIndex) index withObject:(id) object{
    if(object){
        [_safeLock lock];
        if(CFArrayGetCount(_array) > index){
            CFArraySetValueAtIndex(_array, index, (__bridge const void *)(object));
        }
        [_safeLock unlock];
    }
}

-(id)firstObject{
    return [self objectAtIndex:0];
}

-(id)lastObject{
    id retVal = nil;
    [_safeLock lock];
    if(CFArrayGetCount(_array))
        CFArrayGetValueAtIndex(_array, CFArrayGetCount(_array)-1);
    else
        retVal = nil;
    [_safeLock unlock];
    return retVal;
}

-(void)removeAllObjects{
    [_safeLock lock];
    CFArrayRemoveAllValues(_array);
    [_safeLock unlock];
}

-(void)removeObjectsInRange:(NSRange) range{
    unsigned long location = range.location;
    unsigned long length = range.length;
    if(length){
        [_safeLock lock];
        CFIndex count = CFArrayGetCount(_array);
        if(location < count){
            CFIndex max = location + length;
            if(max > count)
                max = count;
            do
                CFArrayRemoveValueAtIndex(_array, location++);
            while(location != max);
        }
        [_safeLock unlock];
    }
}

-(CFIndex)indexOfObject:(id) object{
    CFIndex retVal = 0;
    if(object){
        [_safeLock lock];
        CFIndex count = CFArrayGetCount(_array);
        retVal = CFArrayGetFirstIndexOfValue(_array, CFRangeMake(0, count), (__bridge const void *)(object));
        [_safeLock unlock];
    }else{
        retVal = -1;
    }
    return retVal;
}

-(void)removeFirstObject{
    [_safeLock lock];
    if(CFArrayGetCount(_array)){
        CFArrayRemoveValueAtIndex(_array, 0);
    }
    [_safeLock unlock];
}

-(void)lock{
    [_safeLock lock];
}

-(void)unlock{
    [_safeLock unlock];
}

- (void)dealloc
{
    if(_array){
        CFRelease(_array);
        _array = 0;
    }
}

@end
