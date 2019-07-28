//
//  NSJSONSerialization+CLOCommonJson.h
//  CLOCommon
//
//  Created by Cc on 2019/7/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSJSONSerialization (CLOCommonJson)

+ (nullable NSDictionary *)JSONObjectWithContentsOfURL:(NSURL *)url;

+ (nullable NSDictionary *)JSONObjectWithJsonContentsOfFile:(NSString *)filePath;

/**
 *  把 Json 转换成 Dictionary
 */
+ (nullable NSDictionary *)JSONObjectWithData:(NSData *)data;
/**
 *  把 Dictionary 转换成 Json
 */
+ (nullable NSData *)JSONDataWithDictionary:(NSDictionary *)json;
+ (nullable NSData *)JSONDataWithDictionary:(NSDictionary *)json withOption:(NSJSONWritingOptions)op;

+ (nullable NSDictionary *)JSONObjectWithJsonString:(NSString *)jsonString;

+ (nullable NSArray *)JSONObjectWithArrayData:(NSData *)data;

+ (nullable NSString *)JSONStringWithDictionary:(NSDictionary *)json;

@end

NS_ASSUME_NONNULL_END
