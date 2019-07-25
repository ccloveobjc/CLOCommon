//
//  UIColor+CLOCommonUI.m
//  CLOCommon
//
//  Created by Cc on 15/1/19.
//  Copyright (c) 2015年 PinguoSDK. All rights reserved.
//

#import "UIColor+CLOCommonUI.h"
#import <CLOCommon/CLOCommonCore.h>

@implementation UIColor (CLOCommonUI)

+ (instancetype)CLOColorRed:(NSInteger)red withGreen:(NSInteger)green withBlue:(NSInteger)blue withAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

+ (instancetype)CLOGotColorByHexString:(NSString*)strHex withAlpha:(CGFloat)alpha
{
    NSAssert(strHex && alpha >= 0 && alpha <= 1, @"");
    if (strHex && alpha >= 0 && alpha <= 1.0) {
     
        NSUInteger hexInt = [strHex CLOGotHexValue];
        
        return [self CLOGotColorByHex:hexInt withAlpha:alpha];
    }
    
    return nil;
}

+ (instancetype)CLOGotColorByHex:(NSUInteger)intHex withAlpha:(CGFloat)alpha
{
    if ((!isnan(intHex)) && alpha >= 0 && alpha <= 1) {
        
        CGFloat r = (intHex & 0xFF0000) >> 16;
        CGFloat g = (intHex & 0xFF00) >> 8;
        CGFloat b = intHex & 0xFF;
        
        if ((!isnan(r))
            && (!isnan(g))
            && (!isnan(b))) {
            
            CGFloat r_ = r / 255.0;
            CGFloat g_ = g / 255.0;
            CGFloat b_ = b / 255.0;
            
            return [UIColor colorWithRed:r_ green:g_ blue:b_ alpha:alpha];
        }
        else {
            
            SDKErrorLog(@"(!isnan(r)) && (!isnan(g)) && (!isnan(b))    return NO");
        }
    }
    else {
        
        SDKErrorLog(@"(!isnan(intHex)) && alpha >= 0 && alpha <= 1   return NO");
    }
    
    return nil;
}

- (UIImage *)CLOCreateImageWithColor
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
