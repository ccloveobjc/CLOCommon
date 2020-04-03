//
//  NSArray+CLOCommonCore.m
//  CLOCommon
//
//  Created by Cc on 14/12/9.
//  Copyright (c) 2014年 PinguoSDK. All rights reserved.
//

#import "NSArray+CLOCommonCore.h"
#import "NSObject+CLOCommonCore.h"
#import "CLOLogHelper.h"

@implementation NSArray (CLOCommonCore)

- (id)CLOGotObjectAtIndex:(NSInteger)index
{
    if (index >= 0 && index < self.count) {
        
        return self[index];
    }
   
    return nil;
}

- (NSString *)CLOMakeStringWithNumbers
{
    NSMutableString *retStr = [NSMutableString stringWithString:@""];
    if (self.count > 0) {
        
        for (int i = 0; i < self.count; ++i) {
            
            id value = self[i];
            if ([value isKindOfClass:[NSNumber class]]) {
                
                if (retStr.length != 0) {
                    
                    [retStr appendString:@","];
                }
                
                [retStr appendFormat:@"%@",value];
            }
        }
    }
    
    return retStr;
}

- (CGPoint)CLOGotCGPoint
{
    if (self.count == 2) {
        
        NSNumber *x = [self[0] CLOConvertToClass:[NSNumber class]];
        NSNumber *y = [self[1] CLOConvertToClass:[NSNumber class]];
        if (x && y) {
            
            return CGPointMake([x floatValue], [y floatValue]);
        }
    }
    
    SDKErrorLog(@"c_common_gotCGPoint 解析错误了!   self = %@", self);
    return CGPointZero;
}

@end
