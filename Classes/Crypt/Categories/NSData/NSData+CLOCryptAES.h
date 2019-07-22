//
//  NSData+CLOCryptAES.h
//  CLOCommon
//
//  Created by Cc on 14-10-15.
//  Copyright (c) 2014年 PinguoSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (CLOCryptAES)

/* 256加密 */
- (nullable NSData *)c_CLOEncrypt256WithPassword:(NSString *)password;
- (nullable NSData *)c_CLODecrypt256WithPassword:(NSString *)password;

/* 128加密 */
- (nullable NSData *)c_CLOEncrypt128WithPassword:(NSString*)password;
- (nullable NSData *)c_CLODecrypt128WithPassword:(NSString*)password;

@end

NS_ASSUME_NONNULL_END
