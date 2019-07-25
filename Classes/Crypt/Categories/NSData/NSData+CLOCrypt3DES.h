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

- (nullable NSData *)CLOEncrypt3DESWithKey:(NSString *)oKey withIv:(NSString*)oIv;
- (nullable NSData *)CLODecrypt3DESWithKey:(NSString *)oKey withIv:(NSString*)oIv;

@end

NS_ASSUME_NONNULL_END
