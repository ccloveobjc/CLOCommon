//
//  NSData+CLOCryptBase64.h
//  CLOCommon
//
//  Created by Cc on 2020/3/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (CLOCryptBase64)

+ (NSData *)CLODataWithBase64EncodedString:(NSString *)string;

+ (NSString *)CLODase64EncodedStringFrom:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
