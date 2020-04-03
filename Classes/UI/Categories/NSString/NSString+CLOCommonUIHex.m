//
//  NSString+CLOCommonUIHex.m
//  CLOCommon
//
//  Created by Cc on 16/6/2.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import "NSString+CLOCommonUIHex.h"
#import <CLOCommon/CLOCommonCore.h>

@implementation NSString (CLOCommonUIHex)

- (BOOL)CLOGotColorWithOutR:(NSUInteger *)oR withOutG:(NSUInteger *)oG withOutB:(NSUInteger *)oB
{
    NSUInteger intHex = [self CLOGotHexValue];
    if (!isnan(intHex)) {
        
        CGFloat r = (intHex & 0xFF0000) >> 16;
        CGFloat g = (intHex & 0xFF00) >> 8;
        CGFloat b = intHex & 0xFF;
        
        if ((!isnan(r)) && (!isnan(g)) && (!isnan(b))) {
            
            *oR = r;
            *oG = g;
            *oB = b;
            return YES;
        }
        else {
            
            SDKErrorLog(@"(!isnan(r)) && (!isnan(g)) && (!isnan(b))    return NO");
        }
    }
    else {
        
        SDKErrorLog(@"(!isnan(intHex)) && alpha >= 0 && alpha <= 1   return NO");
    }
    
    return NO;
}

@end
