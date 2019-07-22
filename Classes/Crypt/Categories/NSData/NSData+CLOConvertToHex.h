//
//  NSData+CLOConvertToHex.h
//  CLOCommon
//
//  Created by Cc on 14/11/24.
//  Copyright (c) 2014年 PinguoSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (CLOConvertToHex)

/**
 把二进制文件转成可以看到的string
 */
+ (nullable NSString *)c_CLOConvertToHexString:(NSData *)dataHex;

/**
 把可以看到的string转成二进制文件
 */
+ (nullable instancetype)c_CLOConvertHexStringToData:(NSString *)strHex;

@end

NS_ASSUME_NONNULL_END
