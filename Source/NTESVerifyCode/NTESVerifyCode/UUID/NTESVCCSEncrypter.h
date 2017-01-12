//
//  NTESVCCSEncrypter.h
//  UUID
//
//  Created by NetEase on 16/12/14.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UUIDEncrypter NTESVCCSEncrypter

#ifdef __OPTIMIZE__
#define NTESVCCSEncrypter HTytObilSzdvxJoVdt
#define base64Encoded_CS_UUID EeVmfsnCLrLMZrKK
#define Base64Decode_CS_UUID RvqjaESbbukYzgst
#define AES128_ECB_7_EncryptWithKey_CS_UUID DsMJaNsEHUIcxHog
#define keyC_CS_UUID dDpbhNfMNBPRUfqj
#define AES128_ECB_7_EncryptDataWithKey_CS_UUID OdTIGOtpLVlCOhaW
#define AES128_ECB_7_DecryptWithKey_CS_UUID vcUoXOPiGIPdETos
#define securitySign_CS_UUID cbpUDuCLOlmMxjdv
#define paddingStr_CS_UUID KFSsUPwElzWwxYGE
#endif

@interface NTESVCCSEncrypter : NSObject

+(NSString *)base64Encoded_CS_UUID:(NSData *)data;
+(NSData *)Base64Decode_CS_UUID:(NSString *)string;

+ (NSData *)AES128_ECB_7_EncryptWithKey_CS_UUID:(NSString *)input keyC_CS_UUID:(NSString *)key;
+ (NSData *)AES128_ECB_7_EncryptDataWithKey_CS_UUID:(NSData *)input keyC_CS_UUID:(NSString *)key;
+ (NSData *)AES128_ECB_7_DecryptWithKey_CS_UUID:(NSData *)data keyC_CS_UUID:(NSString *)key;

+ (NSString *)securitySign_CS_UUID:(NSString *)oStr paddingStr_CS_UUID:(NSString *)padding;

@end
