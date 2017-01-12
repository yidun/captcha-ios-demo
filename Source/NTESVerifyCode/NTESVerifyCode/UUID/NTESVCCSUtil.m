//
//  NTESVCCSUtil.m
//  UUID
//
//  Created by NetEase on 16/12/14.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "NTESVCCSUtil.h"

static NSString *NTESCDecodeString(NTESVCCSEncodedString *str) __attribute__ ((always_inline));
NSString *NTESCDecodeString(NTESVCCSEncodedString *str) {
    char seed = str->origstr[str->size-1];
    int j = 0;
    
    do {
        str->origstr[j] ^= seed;
        j++;
    } while(j < str->size);
    
    return [[NSString alloc] initWithBytesNoCopy:str->origstr length:str->size-1 encoding:NSUTF8StringEncoding freeWhenDone:0];
}

@implementation NTESVCCSUtil

+ (NSString *)genErrorString_CS_UUID:(NTESVCCSErrorCode)error {
    NSString *letters = NTESCDecodeString(&_5850BBF9126580);
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:32];
    
    switch(error) {
        case NTESCSErrorCodeFreshUUID:
            [result appendString:NTESCDecodeString(&_5850BDDE139895)];
            break;
        case NTESCSErrorCodeDecryptError:
            [result appendString:NTESCDecodeString(&_5850BE29114515)];
            break;
        case NTESCSErrorCodeNonConsistent:
            [result appendString:NTESCDecodeString(&_5850BE53613079)];
            break;
        case NTESCSErrorCodeException:
            [result appendString:NTESCDecodeString(&_5850C081121007)];
            break;
        default:
            [result appendString:NTESCDecodeString(&_5850C0AB809276)];
            break;
    }
    
    for(int i = 0; i < 27; i++) {
        [result appendFormat:NTESCDecodeString(&_5850BCF7468996), [letters characterAtIndex:arc4random_uniform((unsigned int)letters.length)]];
    }
    
    [result appendString:NTESCDecodeString(&_5850BE02622143)];
    
    return [result copy];
}

@end
