//
//  NSDictionary+PGUnitils.h
//  pg_sdk_common
//
//  Created by Cc on 14-10-11.
//  Copyright (c) 2014年 PinguoSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (pg_common_unitils)

- (nullable id)c_common_gotValueForKey:(nonnull id)key withClass:(__nonnull Class)cls;

- (nullable NSString *)c_common_gotStringForKey:(nonnull id)key;

- (nullable NSArray *)c_common_gotArrayForKey:(nonnull id)key;

- (nullable NSNumber *)c_common_gotNumberForKey:(nonnull id)key;

- (nullable NSDictionary *)c_common_gotDictionaryForKey:(nonnull id)key;

- (nullable NSURL *)c_common_gotURLForKey:(nonnull id)key;

- (BOOL)c_common_gotBOOLForKey:(nonnull id)key;


- (void)c_common_setupValue:(nonnull id)value withKey:(nonnull id)key withClass:(__nonnull Class)cls;

- (void)c_common_setupString:(nonnull NSString *)value withKey:(nonnull id)key;

- (void)c_common_setupURL:(nonnull NSURL *)value withKey:(nonnull id)key;

- (void)c_common_setupNumber:(nonnull NSNumber *)value withKey:(nonnull id)key;

- (void)c_common_setupBOOL:(BOOL)value withKey:(nonnull id)key;


///**
// *  把 Dictionary 转换成 JsonString
// */
//- (nullable NSData *)c_common_convertToJsonData;


/**
 用于签名

 @param strKey sigKey
 @return sig
 */
- (nullable NSString *)c_common_gotSigByKey:(nonnull NSString *)strKey;

@end
