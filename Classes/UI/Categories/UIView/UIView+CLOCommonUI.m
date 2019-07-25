//
//  UIView+CLOCommonUI.m
//  CLOCommon
//
//  Created by Cc on 14-5-13.
//  Copyright (c) 2014年 Pinguo. All rights reserved.
//

#import "UIView+CLOCommonUI.h"

@implementation UIView (CLOCommonUI)

- (NSArray *)CLOGotSubviews:(Class)cls
{
    NSMutableArray *arr = [NSMutableArray array];
    
    for (id obj in self.subviews) {
        
        if ([obj isKindOfClass:cls]) {
            
            [arr addObject:obj];
        }
    }
    
    return arr.count > 0 ? arr : nil;
}

@end
