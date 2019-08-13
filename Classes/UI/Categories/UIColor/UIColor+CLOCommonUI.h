//
//  UIColor+CLOCommonUI.h
//  CLOCommon
//
//  Created by Cc on 15/1/19.
//  Copyright (c) 2015年 PinguoSDK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define CLOHexMake(hex, alp) [UIColor CLOGotColorByHex:hex withAlpha:alp]
#define CLOColorMake(r, g, b, a) [UIColor CLOColorRed:(r) withGreen:(g) withBlue:(b) withAlpha:(a)]

@interface UIColor (CLOCommonUI)

/**
 获取 UIColor
 
 @param red 0 - 255
 @param green 0 - 255
 @param blue 0 - 255
 @param alpha 0 - 1
 @return UIColor
 */
+ (instancetype)CLOColorRed:(NSInteger)red withGreen:(NSInteger)green withBlue:(NSInteger)blue withAlpha:(CGFloat)alpha;

/**
 *  通过一个 hex 格式的 string  转换成 UIColor 对象  例如：@"0xFFFFFF" -> UIColor
 *  alpha = (0 - 1)
 */
+ (nullable instancetype)CLOGotColorByHexString:(NSString*)strHex withAlpha:(CGFloat)alpha;


+ (nullable instancetype)CLOGotColorByHex:(NSUInteger)intHex withAlpha:(CGFloat)alpha;


/**
 *  通过UIColor to UIImage(0, 0, 1, 1)
 */
- (UIImage *)CLOCreateImageWithColor;
@end

NS_ASSUME_NONNULL_END
