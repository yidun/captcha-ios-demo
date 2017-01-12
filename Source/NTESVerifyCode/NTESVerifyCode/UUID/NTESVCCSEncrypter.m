//
//  NTESVCCSEncrypter.m
//  UUID
//
//  Created by NetEase on 16/12/14.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "NTESVCCSEncrypter.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "NTESVCCSDefine.h"

@implementation NTESVCCSEncrypter

+(NSString *)base64Encoded_CS_UUID:(NSData *)data {
    if(!data) {
        return nil;
    }
    
    NSData *tdata = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:tdata encoding:NSUTF8StringEncoding];
    return ret;
}

+(NSData *)Base64Decode_CS_UUID:(NSString *)string {
    if(!string) {
        return nil;
    }
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

+ (NSData *)AES128_ECB_7_EncryptWithKey_CS_UUID:(NSString *)input keyC_CS_UUID:(NSString *)key {
    if(!input || !key) {
        return nil;
    }
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    return [self AES128_ECB_7_EncryptDataWithKey_CS_UUID:data keyC_CS_UUID:key];
}

+ (NSData *)AES128_ECB_7_EncryptDataWithKey_CS_UUID:(NSData *)input keyC_CS_UUID:(NSString *)key {
    if(!input || !key) {
        return nil;
    }
    
    NSData *ret = nil;
    
    //加密
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = input;
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        ret = [NSData dataWithBytes:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return ret;
}

+ (NSData *)AES128_ECB_7_DecryptWithKey_CS_UUID:(NSData *)data keyC_CS_UUID:(NSString *)key {
    if(!data || !key) {
        return nil;
    }
    
    NSData *ret = nil;
    
    //解密
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        ret = [NSData dataWithBytes:buffer length:numBytesDecrypted];
    }
    free(buffer);
    
    return ret;
}

+ (NSString *)securitySign_CS_UUID:(NSString *)oStr paddingStr_CS_UUID:(NSString *)padding {
    DLog(@"data to sign: %@  with padding: %@", oStr, padding);
    
    if(!oStr || !padding) {
        return nil;
    }
    
    if(oStr.length != 30 || padding.length != 32) {
        DLog(@"args length error");
    }
    
    long sum = 0;
    for(unsigned long i = 0; i < oStr.length; i++) {
        char ch = [oStr characterAtIndex:i];
        sum += (int)ch;
    }
    
    for(unsigned long i = 0; i < padding.length; i++) {
        char ch = [padding characterAtIndex:i];
        sum += (int)ch;
    }
    
    NSString *sign = [NSString stringWithFormat:@"%02lx", sum % 100];
    NSString *result = [oStr stringByAppendingString:sign];
    return result;
}

@end
