//
//  NTESVCCSPersisit.m
//  UUID
//
//  Created by NetEase on 16/12/14.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "NTESVCCSPersisit.h"
#import "NTESVCCSDefine.h"
#import "NTESVCCSEncrypter.h"

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

@implementation NTESVCCSPersisit

+ (void)saveSandBox_CS_UUID:(NSString *)value key_CS_UUID:(NSString *)key {
    if(!value || !key) {
        return;
    }
    
    NSData *enData = [UUIDEncrypter AES128_ECB_7_EncryptWithKey_CS_UUID:value keyC_CS_UUID:NTESCDecodeString(&_5850BD79240558)];
    if(!enData) {
        return;
    }
    
    NSString *base64 = [UUIDEncrypter base64Encoded_CS_UUID:enData];
    if(!base64) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:base64 forKey:key];
}

+ (NSString *)getSandBox_CS_UUID:(NSString *)key {
    if(!key) {
        return nil;
    }
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if(!str) {
        return nil;
    }
    
    NSData *data = [UUIDEncrypter Base64Decode_CS_UUID:str];
    if(!data) {
        return NTESCDecodeString(&_5850BC97194999);
    }
    
    NSData *result = [UUIDEncrypter AES128_ECB_7_DecryptWithKey_CS_UUID:data keyC_CS_UUID:NTESCDecodeString(&_5850BD79240558)];
    if(!result) {
        return NTESCDecodeString(&_5850BC97194999);
    }
    
    NSString *tp = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    if(!tp) {
        return NTESCDecodeString(&_5850BC97194999);
    }
    
    return tp;
}

+ (void)saveKeyChain_CS_UUID:(NSString *)value key_CS_UUID:(NSString *)key group_CS_UUID:(NSString *)group {
    if(!value || !key || !group) {
        return;
    }
    
    NSData *enData = [UUIDEncrypter AES128_ECB_7_EncryptWithKey_CS_UUID:value keyC_CS_UUID:NTESCDecodeString(&_5850BD79240558)];
    if(!enData) {
        return;
    }
    
    NSString *base64 = [UUIDEncrypter base64Encoded_CS_UUID:enData];
    if(!base64) {
        return;
    }
    
    NSString *exsit = [self getKeyChain_CS_UUID:key group_CS_UUID:group];
    NSArray* attr = nil;
    NSArray* objs = nil;
    OSStatus status = 0;
    if(exsit != nil) {
        attr = [[NSArray alloc] initWithObjects:(NSString*)kSecClass,kSecAttrService,kSecAttrLabel,kSecAttrAccount,kSecAttrAccessible, nil];
        objs = [[NSArray alloc] initWithObjects:(NSString*)kSecClassGenericPassword,group,group,key,(NSString*)kSecAttrAccessibleWhenUnlocked,nil];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithObjects:objs forKeys:attr];
        
        NSData *data = [base64 dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* updateDic = [NSDictionary dictionaryWithObject:data forKey:(NSString*)kSecValueData];
        
        status = SecItemUpdate((CFDictionaryRef)dic, (CFDictionaryRef)updateDic);
    } else {
        attr = [[NSArray alloc] initWithObjects:(__bridge id)kSecClass,kSecAttrService,kSecAttrLabel,kSecAttrAccount,kSecValueData,kSecAttrAccessible, nil];
        objs = [[NSArray alloc] initWithObjects:(__bridge id)kSecClassGenericPassword,group,group,key,[base64 dataUsingEncoding:NSUTF8StringEncoding],(NSString*)kSecAttrAccessibleWhenUnlocked,nil];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithObjects:objs forKeys:attr];
        status = SecItemAdd((__bridge CFDictionaryRef)dic, 0);
    }
    
    if(status != noErr){
        DLog(@"save to keychain error");
    }
    
    return;
}

+ (NSString *)getKeyChain_CS_UUID:(NSString *)key group_CS_UUID:(NSString *)group {
    if(!key || !group) {
        return nil;
    }
    
    NSString *rr = nil;
    
    NSArray* attr = [[NSArray alloc]  initWithObjects:(__bridge id)kSecClass,kSecAttrAccount,kSecAttrService,(__bridge id)kSecReturnAttributes,(__bridge id)kSecReturnData,nil];
    NSArray* objs = [[NSArray alloc] initWithObjects:(__bridge id)kSecClassGenericPassword,key,group,(id)kCFBooleanTrue,(id)kCFBooleanTrue,nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithObjects:objs forKeys:attr];
    NSData *value = nil;
    CFTypeRef result = (__bridge CFTypeRef)value;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)dic, &result);
    if(status == noErr) {
        NSData* data = [(__bridge NSDictionary *)result objectForKey:(__bridge id)(kSecValueData)];
        rr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        CFRelease(result);
    } else {
        return nil;
    }
    
    if(!rr) {
        return nil;
    }
    
    NSData *datat = [UUIDEncrypter Base64Decode_CS_UUID:rr];
    if(!datat) {
        return NTESCDecodeString(&_5850BC97194999);
    }
    
    NSData *resultt = [UUIDEncrypter AES128_ECB_7_DecryptWithKey_CS_UUID:datat keyC_CS_UUID:NTESCDecodeString(&_5850BD79240558)];
    if(!resultt) {
        return NTESCDecodeString(&_5850BC97194999);
    }
    
    NSString *tpresult = [[NSString alloc] initWithData:resultt encoding:NSUTF8StringEncoding];
    if(!tpresult) {
        return NTESCDecodeString(&_5850BC97194999);
    }
    
    return tpresult;
}

@end
