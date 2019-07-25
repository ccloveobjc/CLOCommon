//
//  NSObject+CLOCommonCore.h
//  CLOCommon
//
//  Created by Cc on 2019/7/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CLOCommonCore)

- (nullable id)CLOConvertToClass:(Class)oClass;

+ (void)CLOEnablePropertyForKey:(BOOL)bEnable;
/**
 *  有性能问题 DEBUG 才会使用
 */
- (BOOL)CLOPropertyForKey:(NSString *)key;


+ (CGRect)CLOConvertCGRectNaN:(CGRect)rect;


/**
 *  获取当前Class 的所有属性
 */
- (NSArray<NSString *> *)CLOGotPropertiesNameOnThisClass;

@end

NS_ASSUME_NONNULL_END
