//
//  NSBundle+CLOCommonCore.h
//  CLOCommon
//
//  Created by Cc on 14/12/9.
//  Copyright (c) 2014年 PinguoSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (CLOCommonCore)

+ (NSBundle *)CLOBundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName;

@end

NS_ASSUME_NONNULL_END
