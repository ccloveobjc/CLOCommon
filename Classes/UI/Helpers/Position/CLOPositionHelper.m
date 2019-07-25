//
//  CLOPositionHelper.m
//  CLOCommon
//
//  Created by Cc on 2018/4/8.
//

#import "CLOPositionHelper.h"

@implementation CLOPositionHelper

+ (CGFloat)sGetStatusBarHeight
{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    return rectStatus.size.height;
}


+ (CGFloat)sGetiPhoneXBottomHeight
{
    if (kCLO_IS_IPHONEX) {
        
        return 34;
    }
    
    return 0;
}


@end
