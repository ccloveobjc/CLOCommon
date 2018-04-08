//
//  CLOLogMgr.m
//  CLOAlbum
//
//  Created by Cc on 2018/1/6.
//

#import "CLOColorHelper.h"

@implementation CLOColorHelper

+ (UIColor *)fColorRed:(NSInteger)red withGreen:(NSInteger)green withBlue:(NSInteger)blue withAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

@end
