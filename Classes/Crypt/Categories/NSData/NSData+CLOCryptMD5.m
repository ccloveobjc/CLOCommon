//
//  NSData+CLOCryptMD5.m
//  CLOCommon
//
//  Created by Cc on 14/10/27.
//  Copyright (c) 2014年 PinguoSDK. All rights reserved.
//

#import "NSData+CLOCryptMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (CLOCryptMD5)

- (NSString *)CLOEncryptWithMD5
{
    NSData *sData = self;
//    const char *cStr = sData.bytes;
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(sData.bytes, (CC_LONG)sData.length, digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

@end
