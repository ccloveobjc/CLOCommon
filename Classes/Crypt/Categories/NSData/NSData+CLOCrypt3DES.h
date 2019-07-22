//
//  NSObject+CLOCrypt3DES.h
//  CLOCommon
//
//  Created by Cc on 15/3/10.
//  Copyright (c) 2015年 PinguoSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (CLOCrypt3DES)

- (nullable NSData *)c_CLOEncrypt3DESWithKey:(NSString *)oKey withIv:(NSString*)oIv;
- (nullable NSData *)c_CLODecrypt3DESWithKey:(NSString *)oKey withIv:(NSString*)oIv;

@end

NS_ASSUME_NONNULL_END
