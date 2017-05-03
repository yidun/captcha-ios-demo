//
//  NTESVCCSUUID.m
//  UUID
//
//  Created by NetEase on 16/12/14.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "NTESVCCSUUID.h"
#import "NTESVCCSPersisit.h"
#import <UIKit/UIKit.h>
#import "NTESVCCSEncrypter.h"
#import "NTESVCCSDefine.h"
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

#ifdef __OPTIMIZE__
#define generateFreshUUID jBoCRvLfcSOfPXMz
#endif

@implementation NTESVCCSUUID

+ (NSString *)getUUID {
    @try {
        //DLog(@"UUID version: %@", UUID_VERSION);
        
        NSString *sandboxKey = NTESCDecodeString(&_5850BAFF102454);
        NSString *keychainKey = NTESCDecodeString(&_5850BB36110756);
        NSString *keychainGroup = NTESCDecodeString(&_5850BB5B510642);
        
        NSString *uuidSandbox = [UUIDPersister getSandBox_CS_UUID:sandboxKey];
        NSString *uuidKeychain = [UUIDPersister getKeyChain_CS_UUID:keychainKey group_CS_UUID:keychainGroup];
        
        if(uuidKeychain || uuidSandbox) {
            if((uuidSandbox && [uuidSandbox isEqualToString:NTESCDecodeString(&_5850BC97194999)]) ||
               (uuidKeychain && [uuidKeychain isEqualToString:NTESCDecodeString(&_5850BC97194999)])) {
                return [UUIDUtiler genErrorString_CS_UUID:NTESCSErrorCodeDecryptError];
            }
        }
        
        if(!uuidSandbox && !uuidKeychain) {
            NSString *uuid = [self generateFreshUUID];
            if(!uuid) {
                return [UUIDUtiler genErrorString_CS_UUID:NTESCSErrorCodeFreshUUID];
            }
            
            [UUIDPersister saveSandBox_CS_UUID:uuid key_CS_UUID:sandboxKey];
            [UUIDPersister saveKeyChain_CS_UUID:uuid key_CS_UUID:keychainKey group_CS_UUID:keychainGroup];
            return uuid;
        }
        
        if(!uuidSandbox || !uuidKeychain) {
            if(uuidSandbox) {
                [UUIDPersister saveKeyChain_CS_UUID:uuidSandbox key_CS_UUID:keychainKey group_CS_UUID:keychainGroup];
            } else {
                [UUIDPersister saveSandBox_CS_UUID:uuidKeychain key_CS_UUID:sandboxKey];
            }
            
            return uuidSandbox != nil ? uuidSandbox : uuidKeychain;
        }
        
        if(![uuidSandbox isEqualToString:uuidKeychain]) {
            return [UUIDUtiler genErrorString_CS_UUID:NTESCSErrorCodeNonConsistent];
        }
        
        return uuidSandbox;
    } @catch (NSException *exception) {
        DLog(@"exeption: %@", [exception callStackSymbols]);
        return [UUIDUtiler genErrorString_CS_UUID:NTESCSErrorCodeException];
    }
}

+ (NSString *)generateFreshUUID {
    NSString *uuid = nil;
    NSString *ver = [UIDevice currentDevice].systemVersion;
    if(ver && ver.floatValue >= 6.0) {
        uuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    }
    
    if(!uuid) {
        CFUUIDRef tuuid = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, tuuid);        
        uuid = [NSString stringWithFormat:@"%@", cfstring];
        
        CFRelease(cfstring);
        CFRelease(tuuid);
    }
    
    NSString *letters = NTESCDecodeString(&_5850BBF9126580);
    if(!uuid) {
        NSMutableString *tuuid = [[NSMutableString alloc] initWithCapacity:32];
        for(int i = 0; i < 32; i++) {
            [tuuid appendFormat:NTESCDecodeString(&_5850BCF7468996), [letters characterAtIndex:arc4random_uniform((unsigned int)letters.length)]];
        }
        
        uuid = [tuuid copy];
    }
    
    if(uuid) {
        uuid = [uuid stringByReplacingOccurrencesOfString:NTESCDecodeString(&_5850BD35453172) withString:@""];
        if(uuid.length < 32) {
            NSMutableString *tuuid = [[NSMutableString alloc] initWithCapacity:32];
            for(int i = 0; i < 32 - uuid.length; i++) {
                [tuuid appendFormat:NTESCDecodeString(&_5850BCF7468996), [letters characterAtIndex:arc4random_uniform((unsigned int)letters.length)]];
            }
            [tuuid appendString:uuid];
            
            uuid = [tuuid copy];
        }
        
        if(uuid.length > 30) {
            uuid = [uuid substringToIndex:30];
        }
        
        uuid = [UUIDEncrypter securitySign_CS_UUID:[uuid lowercaseString] paddingStr_CS_UUID:NTESCDecodeString(&_5850BB93100425)];
    }
    
    return uuid;
}

@end
