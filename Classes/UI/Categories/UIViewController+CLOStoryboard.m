//
//  UIViewController+CLOStoryboard.m
//  CLOCommon
//
//  Created by Cc on 2019/7/19.
//  Copyright © 2019 Cc. All rights reserved.
//

#import "UIViewController+CLOStoryboard.h"

@implementation UIViewController (CLOStoryboard)

+ (UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier withStoryboardName:(NSString *)storyboardName
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    NSAssert(storyboard != nil, @"无效的Storyboard");
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:identifier];
    NSAssert(viewController != nil, @"无效的identifier");
    return viewController;
}
@end
