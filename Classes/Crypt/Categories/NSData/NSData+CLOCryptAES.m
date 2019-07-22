//
//  NSData+CLOCryptAES.m
//  CLOCommon
//
//  Created by Cc on 14-10-15.
//  Copyright (c) 2014年 PinguoSDK. All rights reserved.
//

#import "NSData+CLOCryptAES.h"
#import <CommonCrypto/CommonCryptor.h>
#import "CLOLogHelper.h"

@implementation NSData (CLOCryptAES)

- (NSData *)c_CLOEncrypt256WithPassword:(NSString *)password
{
    NSData *encryptedData = nil;
    
    if ([password isKindOfClass:[NSString class]]) {
        
        NSData *sourceData = self;
        char keyPtr[kCCKeySizeAES256+1];
        bzero(keyPtr, sizeof(keyPtr));
        [password getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
        NSUInteger dataLength = [sourceData length];
        size_t bufferSize = dataLength + kCCKeySizeAES256;
        void *buffer = malloc(bufferSize);
        size_t numBytesEncrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                              kCCAlgorithmAES128,
                                              kCCOptionPKCS7Padding,
                                              keyPtr,
                                              kCCKeySizeAES256,
                                              NULL,
                                              [sourceData bytes],
                                              dataLength,
                                              buffer,
                                              bufferSize,
                                              &numBytesEncrypted);
        if (cryptStatus == kCCSuccess) {
            
            encryptedData = [[NSData alloc] initWithBytes:buffer length:numBytesEncrypted];
        }
        else {
            
            SDKErrorLog(@"CCCrypt return NO");
        }
        
        free(buffer);
    }
    else {
        
        SDKErrorLog(@"[password isKindOfClass:[NSString class]]    return NO");
    }
    
    return encryptedData;
}

- (NSData *)c_CLODecrypt256WithPassword:(NSString *)password
{
    NSData *decryptedData = nil;
    if ([password isKindOfClass:[NSString class]]) {
     
        NSData *sourceData = self;
        char keyPtr[kCCKeySizeAES256+1];
        bzero(keyPtr, sizeof(keyPtr));
        [password getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
        NSUInteger dataLength = [sourceData length];
        size_t bufferSize = dataLength + kCCKeySizeAES256;
        void *buffer = malloc(bufferSize);
        size_t numBytesDecrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                              kCCAlgorithmAES128,
                                              kCCOptionPKCS7Padding,
                                              keyPtr,
                                              kCCKeySizeAES256,
                                              NULL,
                                              [sourceData bytes],
                                              dataLength,
                                              buffer,
                                              bufferSize,
                                              &numBytesDecrypted);
        if (cryptStatus == kCCSuccess) {
            
            decryptedData = [[NSData alloc] initWithBytes:buffer length:numBytesDecrypted];
        }
        else {
            
            SDKErrorLog(@"CCCrypt return NO");
        }
        
        free(buffer);
    }
    else {
        
        SDKErrorLog(@"[password isKindOfClass:[NSString class]]    return NO");
    }
    
    return decryptedData;
}

- (NSData *)c_CLOEncrypt128WithPassword:(NSString *)password
{
    NSData *encryptedData = nil;
    
    if ([password isKindOfClass:[NSString class]]) {
        
        NSData *sourceData = self;
        char keyPtr[kCCKeySizeAES256+1];
        bzero(keyPtr, sizeof(keyPtr));
        [password getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
        NSUInteger dataLength = [sourceData length];
        size_t bufferSize = dataLength + kCCKeySizeAES128;
        void *buffer = malloc(bufferSize);
        size_t numBytesEncrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                              kCCAlgorithmAES128,
                                              kCCOptionPKCS7Padding,
                                              keyPtr,
                                              kCCKeySizeAES128,
                                              NULL,
                                              [sourceData bytes],
                                              dataLength,
                                              buffer,
                                              bufferSize,
                                              &numBytesEncrypted);
        if (cryptStatus == kCCSuccess) {
            
            encryptedData = [[NSData alloc] initWithBytes:buffer length:numBytesEncrypted];
        }
        else {
            
            SDKErrorLog(@"CCCrypt return NO");
        }
        
        free(buffer);
    }
    else {
        
        SDKErrorLog(@"[password isKindOfClass:[NSString class]]    return NO");
    }
    
    return encryptedData;
}

- (NSData *)c_CLODecrypt128WithPassword:(NSString *)password
{
    NSData *decryptedData = nil;
    
    if ([password isKindOfClass:[NSString class]]) {
        
        NSData *sourceData = self;
        char keyPtr[kCCKeySizeAES256+1];
        bzero(keyPtr, sizeof(keyPtr));
        [password getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
        NSUInteger dataLength = [sourceData length];
        size_t bufferSize = dataLength + kCCKeySizeAES128;
        void *buffer = malloc(bufferSize);
        size_t numBytesDecrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                              kCCAlgorithmAES128,
                                              kCCOptionPKCS7Padding,
                                              keyPtr,
                                              kCCKeySizeAES128,
                                              NULL,
                                              [sourceData bytes],
                                              dataLength,
                                              buffer,
                                              bufferSize,
                                              &numBytesDecrypted);
        if (cryptStatus == kCCSuccess) {
            
            decryptedData = [[NSData alloc] initWithBytes:buffer length:numBytesDecrypted];
        }
        else {
            
            SDKErrorLog(@"CCCrypt return NO");
        }
        
        free(buffer);
    }
    else {
        
        SDKErrorLog(@"[password isKindOfClass:[NSString class]]    return NO");
    }
    
    return decryptedData;
}

@end
