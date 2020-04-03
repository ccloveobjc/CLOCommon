//
//  NSData+CLOCrypt3DES.m
//  CLOCommon
//
//  Created by Cc on 15/3/10.
//  Copyright (c) 2015年 PinguoSDK. All rights reserved.
//

#import "NSData+CLOCrypt3DES.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CLOCommon/CLOCommonCore.h>

@implementation NSData (CLOCrypt3DES)

- (NSData *)CLOEncrypt3DESWithKey:(NSString *)oKey withIv:(NSString*)oIv
{
    NSData *encryptedData = nil;
    
    if ([oKey isKindOfClass:[NSString class]] && [oIv isKindOfClass:[NSString class]]) {
        
        NSData *data = self;
        size_t plainTextBufferSize = [data length];
        const void *vplainText = (const void *)[data bytes];
        
        uint8_t *bufferPtr = NULL;
        size_t bufferPtrSize = 0;
        size_t movedBytes = 0;
        
        bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
        bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
        memset((void *)bufferPtr, 0x0, bufferPtrSize);
        
        const void *vkey = (const void *) [oKey UTF8String];
        const void *vinitVec = (const void *) [oIv UTF8String];
        
        CCCryptorStatus ccStatus = CCCrypt(kCCEncrypt,
                                           kCCAlgorithmDES,
                                           kCCOptionPKCS7Padding,
                                           vkey,
                                           kCCKeySizeDES,
                                           vinitVec,
                                           vplainText,
                                           plainTextBufferSize,
                                           (void *)bufferPtr,
                                           bufferPtrSize,
                                           &movedBytes);
        
        if (ccStatus == kCCSuccess) {
            
            encryptedData = [[NSData alloc] initWithBytes:bufferPtr length:movedBytes];
        }
        else {
            
            SDKErrorLog(@"CCCrypt return NO");
        }
        
        free(bufferPtr);
    }
    else {
        
        SDKErrorLog(@"[oKey isKindOfClass:[NSString class]] && [oIv isKindOfClass:[NSString class]]    return NO");
    }
    
    return encryptedData;
}

- (NSData *)CLODecrypt3DESWithKey:(NSString *)oKey withIv:(NSString*)oIv
{
    NSData *encryptedData = nil;
    
    if ([oKey isKindOfClass:[NSString class]] && [oIv isKindOfClass:[NSString class]]) {
        
        NSData *encryptData = self;
        size_t plainTextBufferSize = [encryptData length];
        const void *vplainText = [encryptData bytes];
        
        uint8_t *bufferPtr = NULL;
        size_t bufferPtrSize = 0;
        size_t movedBytes = 0;
        bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
        bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
        memset((void *)bufferPtr, 0x0, bufferPtrSize);
        const void *vkey = (const void *) [oKey UTF8String];
        const void *vinitVec = (const void *) [oIv UTF8String];
        
        CCCryptorStatus ccStatus = CCCrypt(kCCDecrypt,
                                           kCCAlgorithmDES,
                                           kCCOptionPKCS7Padding,
                                           vkey,
                                           kCCKeySizeDES,
                                           vinitVec,
                                           vplainText,
                                           plainTextBufferSize,
                                           (void *)bufferPtr,
                                           bufferPtrSize,
                                           &movedBytes);
        
        if (ccStatus == kCCSuccess) {
            
            encryptedData = [[NSData alloc] initWithBytes:bufferPtr length:movedBytes];
        }
        else {
            
            SDKErrorLog(@"CCCrypt return NO");
        }
        free(bufferPtr);
    }
    else {
        
        SDKErrorLog(@"[oKey isKindOfClass:[NSString class]] && [oIv isKindOfClass:[NSString class]]    return NO");
    }
    
    return encryptedData;
}

@end
