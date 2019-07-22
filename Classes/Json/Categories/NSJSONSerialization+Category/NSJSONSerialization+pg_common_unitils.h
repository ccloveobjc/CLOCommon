//
//  NSJSONSerialization+PGUnitils.h
//  MIX_SDKDEMO
//
//  Created by Cc on 14-6-2.
//  Copyright (c) 2014年 权欣权忆. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  扩展
 */
@interface NSJSONSerialization (pg_common_unitils)

+ (nullable NSDictionary *)c_common_JSONObjectWithContentsOfURL:(NSURL *)url;

+ (nullable NSDictionary *)c_common_JSONObjectWithJsonContentsOfFile:(NSString *)filePath;

/**
 *  把 Json 转换成 Dictionary
 */
+ (nullable NSDictionary *)c_common_JSONObjectWithData:(NSData *)data;
/**
 *  把 Dictionary 转换成 Json
 */
+ (nullable NSData *)c_common_JSONDataWithDictionary:(NSDictionary *)json;
+ (nullable NSData *)c_common_JSONDataWithDictionary:(NSDictionary *)json withOption:(NSJSONWritingOptions)op;

+ (nullable NSDictionary *)c_common_JSONObjectWithJsonString:(NSString *)jsonString;

+ (nullable NSArray *)c_common_JSONObjectWithArrayData:(NSData *)data;

@end
NS_ASSUME_NONNULL_END
