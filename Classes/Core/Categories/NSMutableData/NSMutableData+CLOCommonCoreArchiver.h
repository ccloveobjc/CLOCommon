//
//  NSMutableData+CLOCommonCoreArchiver.h
//  CLOCommon
//
//  Created by Cc on 16/4/7.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
@interface NSMutableData (CLOCommonCoreArchiver)

/**
 *  对象 转换 NSData
 */
+ (instancetype)CLOArchiver:(id<NSCoding>)obj;

/**
 *  Data 转成 对象
 */
+ (id)CLOUnarchiver:(NSData *)data;

@end
NS_ASSUME_NONNULL_END
