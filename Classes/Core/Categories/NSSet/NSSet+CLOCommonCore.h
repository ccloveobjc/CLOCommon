//
//  NSSet+CLOCommonCore.h
//  CLOCommon
//
//  Created by Cc on 14-10-14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSSet (CLOCommonCore)

#pragma mark - 查询
- (nullable id)CLOSearchCommonFirstObjectByKey:(NSString *)key byValue:(NSString *)value;

- (nullable NSArray *)CLOSearchCommonAllObjectByKey:(NSString *)key byValue:(NSString *)value;

- (nullable NSArray *)CLOSearchCommonAllObjectByPredicates:(nullable NSArray *)aPredicates;

#pragma mark - 排序
- (nullable NSArray*)CLOSortCommonDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending;

@end

NS_ASSUME_NONNULL_END
