//
//  NSString+CLOCommonCore.h
//  CLOCommon
//
//  Created by Cc on 9/11/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CLOCommonCore)

/**
 *  是否包含str
 */
- (BOOL)CLOIsRangeOfString:(NSString *)str;

/**
 *  删除string
 */
- (NSString *)CLORemoveOccurrencesOfString:(NSString *)str;


/**
 *  string 拆分成一个一个的 number by ","
 * return  @[@(number),@(number), ... ,@(number)]
 */
- (nullable NSMutableArray<NSNumber *> *)CLOGotFloatArray;

/**
 *  NSString(hex) to NSUInteger(hex)
 */
- (NSUInteger)CLOGotHexValue;

/**
 *  从文件路径中获取数据 转换成UTF8 String
 */
- (nullable instancetype)CLOGotUTF8StringFromFilePath;

/**
 *  检查string 是否符合 Effect=A
 *
 *  @return 符合的字符串
 */
- (instancetype)CLOCheckEffectString;



/**
 转义 用于网络请求

 @return NSString
 */
- (NSString *)CLOEncodeToWebSafeEscapeString;


/**
 获取当前时间

 @return String
 */
+ (NSString *)CLOGotDateFormat:(NSDate *)pDate;

@end

NS_ASSUME_NONNULL_END
