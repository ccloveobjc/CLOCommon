//
//  NSArray+CLOCommonCore.h
//  CLOCommon
//
//  Created by Cc on 14/12/9.
//  Copyright (c) 2014年 PinguoSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (CLOCommonCore)

/**
 *  安全取下标在数组中的值
 */
- (nullable id)CLOGotObjectAtIndex:(NSInteger)index;

/**
 *  制作string 通过一组number  @[@(number),@(number)] -> "number,number"
 */
- (NSString *)CLOMakeStringWithNumbers;

/**
 解析成CGPoint  @[@1,@2] => CGPoint(1,2)

 @return 如果解析失败返回 CGPointZore
 */
- (CGPoint)CLOGotCGPoint;


/**
 *  制作string 通过一组number  @[@"string1",@"string2"] -> "string1,string2"
 */
- (NSString *)CLOMakeStringWithStrings;

@end

NS_ASSUME_NONNULL_END
