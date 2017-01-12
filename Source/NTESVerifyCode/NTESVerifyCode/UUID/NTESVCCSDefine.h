//
//  NTESVCCSDefine.h
//  UUID
//
//  Created by NetEase on 16/12/14.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#ifndef NTESCSDefine_h
#define NTESCSDefine_h

#define UUID_VERSION        @"1.0.0"

typedef struct _NTESVCCSEncodedString{
    char* origstr;
    int size;
    int type;
} NTESVCCSEncodedString;
#define NTESCS_ENCODE_TYPE      0 //XOR

#ifndef __OPTIMIZE__
#define DLog(...) NSLog(__VA_ARGS__)
#else
#define DLog(...)
#endif

typedef NS_ENUM(long, NTESVCCSErrorCode) {
    NTESCSErrorCodeFreshUUID = 126,
    NTESCSErrorCodeDecryptError,
    NTESCSErrorCodeNonConsistent,
    NTESCSErrorCodeException,
};

#pragma mark - uuid
// "ntescs.uuid.key.bBcONsvKrWyLBDGG"
static unsigned char _5850BAFF1024546426390[] = { 0xEA, 0xF0, 0xE1, 0xF7, 0xE7, 0xF7, 0xAA, 0xF1, 0xF1, 0xED, 0xE0, 0xAA, 0xEF, 0xE1, 0xFD, 0xAA, 0xE6, 0xC6, 0xE7, 0xCB, 0xCA, 0xF7, 0xF2, 0xCF, 0xF6, 0xD3, 0xFD, 0xC8, 0xC6, 0xC0, 0xC3, 0xC3, 0x84 };
static NTESVCCSEncodedString _5850BAFF102454 = { (char *)_5850BAFF1024546426390, sizeof(_5850BAFF1024546426390), NTESCS_ENCODE_TYPE };
// "ntescs.keychain.key.NanpJhYaCUdQKAYA"
static unsigned char _5850BB36110756324620[] = { 0x8A, 0x90, 0x81, 0x97, 0x87, 0x97, 0xCA, 0x8F, 0x81, 0x9D, 0x87, 0x8C, 0x85, 0x8D, 0x8A, 0xCA, 0x8F, 0x81, 0x9D, 0xCA, 0xAA, 0x85, 0x8A, 0x94, 0xAE, 0x8C, 0xBD, 0x85, 0xA7, 0xB1, 0x80, 0xB5, 0xAF, 0xA5, 0xBD, 0xA5, 0xE4 };
static NTESVCCSEncodedString _5850BB36110756 = { (char *)_5850BB36110756324620, sizeof(_5850BB36110756324620), NTESCS_ENCODE_TYPE };
// "ntescs.keychain.group.UoKgsGmdMiftMrVt"
static unsigned char _5850BB5B510642753160[] = { 0x53, 0x49, 0x58, 0x4E, 0x5E, 0x4E, 0x13, 0x56, 0x58, 0x44, 0x5E, 0x55, 0x5C, 0x54, 0x53, 0x13, 0x5A, 0x4F, 0x52, 0x48, 0x4D, 0x13, 0x68, 0x52, 0x76, 0x5A, 0x4E, 0x7A, 0x50, 0x59, 0x70, 0x54, 0x5B, 0x49, 0x70, 0x4F, 0x6B, 0x49, 0x3D };
static NTESVCCSEncodedString _5850BB5B510642 = { (char *)_5850BB5B510642753160, sizeof(_5850BB5B510642753160), NTESCS_ENCODE_TYPE };
// "EWFfpoOafVqWPcNNtCPiQiFNLwAqOPCf"
static unsigned char _5850BB931004253468363[] = { 0xD1, 0xC3, 0xD2, 0xF2, 0xE4, 0xFB, 0xDB, 0xF5, 0xF2, 0xC2, 0xE5, 0xC3, 0xC4, 0xF7, 0xDA, 0xDA, 0xE0, 0xD7, 0xC4, 0xFD, 0xC5, 0xFD, 0xD2, 0xDA, 0xD8, 0xE3, 0xD5, 0xE5, 0xDB, 0xC4, 0xD7, 0xF2, 0x94 };
static NTESVCCSEncodedString _5850BB93100425 = { (char *)_5850BB931004253468363, sizeof(_5850BB931004253468363), NTESCS_ENCODE_TYPE };
// "abcdefABCDEF0123456789"
static unsigned char _5850D6D5315373632894[] = { 0xE3, 0xE0, 0xE1, 0xE6, 0xE7, 0xE4, 0xC3, 0xC0, 0xC1, 0xC6, 0xC7, 0xC4, 0xB2, 0xB3, 0xB0, 0xB1, 0xB6, 0xB7, 0xB4, 0xB5, 0xBA, 0xBB, 0x82 };
static NTESVCCSEncodedString _5850BBF9126580 = { (char *)_5850D6D5315373632894, sizeof(_5850D6D5315373632894), NTESCS_ENCODE_TYPE };
// "decrypt_error"
static unsigned char _5850BC97194999679230[] = { 0xD0, 0xD1, 0xD7, 0xC6, 0xCD, 0xC4, 0xC0, 0xEB, 0xD1, 0xC6, 0xC6, 0xDB, 0xC6, 0xB4 };
static NTESVCCSEncodedString _5850BC97194999 = { (char *)_5850BC97194999679230, sizeof(_5850BC97194999679230), NTESCS_ENCODE_TYPE };
// "%C"
static unsigned char _5850BCF746899654941[] = { 0x63, 0x05, 0x46 };
static NTESVCCSEncodedString _5850BCF7468996 = { (char *)_5850BCF746899654941, sizeof(_5850BCF746899654941), NTESCS_ENCODE_TYPE };
// "-"
static unsigned char _5850BD35453172363781[] = { 0xC5, 0xE8 };
static NTESVCCSEncodedString _5850BD35453172 = { (char *)_5850BD35453172363781, sizeof(_5850BD35453172363781), NTESCS_ENCODE_TYPE };

#pragma mark - file
// "kfv61U5rAfVcipCCO"
static unsigned char _5850BD7924055878473[] = { 0x8E, 0x83, 0x93, 0xD3, 0xD4, 0xB0, 0xD0, 0x97, 0xA4, 0x83, 0xB3, 0x86, 0x8C, 0x95, 0xA6, 0xA6, 0xAA, 0xE5 };
static NTESVCCSEncodedString _5850BD79240558 = { (char *)_5850BD7924055878473, sizeof(_5850BD7924055878473), NTESCS_ENCODE_TYPE };

#pragma mark - util
// "126"
static unsigned char _5850BE02622143935130[] = { 0x07, 0x04, 0x00, 0x36 };
static NTESVCCSEncodedString _5850BE02622143 = { (char *)_5850BE02622143935130, sizeof(_5850BE02622143935130), NTESCS_ENCODE_TYPE };
// "00"
static unsigned char _5850C0AB809276384090[] = { 0x91, 0x91, 0xA1 };
static NTESVCCSEncodedString _5850C0AB809276 = { (char *)_5850C0AB809276384090, sizeof(_5850C0AB809276384090), NTESCS_ENCODE_TYPE };
// "10"
static unsigned char _5850BDDE139895692649[] = { 0x2F, 0x2E, 0x1E };
static NTESVCCSEncodedString _5850BDDE139895 = { (char *)_5850BDDE139895692649, sizeof(_5850BDDE139895692649), NTESCS_ENCODE_TYPE };
// "20"
static unsigned char _5850BE291145155523778[] = { 0x2E, 0x2C, 0x1C };
static NTESVCCSEncodedString _5850BE29114515 = { (char *)_5850BE291145155523778, sizeof(_5850BE291145155523778), NTESCS_ENCODE_TYPE };
// "30"
static unsigned char _5850BE53613079286240[] = { 0x0B, 0x08, 0x38 };
static NTESVCCSEncodedString _5850BE53613079 = { (char *)_5850BE53613079286240, sizeof(_5850BE53613079286240), NTESCS_ENCODE_TYPE };
// "40"
static unsigned char _5850C0811210072318427[] = { 0x63, 0x67, 0x57 };
static NTESVCCSEncodedString _5850C081121007 = { (char *)_5850C0811210072318427, sizeof(_5850C0811210072318427), NTESCS_ENCODE_TYPE };

#endif /* NTESCSDefine_h */
