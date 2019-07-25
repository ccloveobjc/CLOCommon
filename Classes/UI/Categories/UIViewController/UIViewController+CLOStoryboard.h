//
//  UIViewController+CLOStoryboard.h
//  CLOCommon
//
//  Created by Cc on 2019/7/19.
//  Copyright © 2019 Cc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (CLOStoryboard)

+ (UIViewController *)CLOInstantiateViewControllerWithIdentifier:(NSString *)identifier withStoryboardName:(NSString *)storyboardName;

@end

NS_ASSUME_NONNULL_END
