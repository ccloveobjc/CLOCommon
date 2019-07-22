//
//  NSObject+pg_common_unit.h
//  pg_sdk_common
//
//  Created by Cc on 15/3/5.
//  Copyright (c) 2015年 PinguoSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSObject (pg_common_class)

- (nullable id)c_common_convertToClass:(Class)oClass;

    + (void)c_common_enablePropertyForKey:(BOOL)bEnable;
/**
 *  有性能问题 DEBUG 才会使用
 */
- (BOOL)c_common_propertyForKey:(NSString *)key;


    + (CGRect)c_common_convertCGRectNaN:(CGRect)rect;


/**
 *  获取当前Class 的所有属性
 */
- (NSArray<NSString *> *)gotPropertiesNameOnThisClass;

@end
NS_ASSUME_NONNULL_END
