//
//  NSBundle+CLOCommonCore.m
//  CLOCommon
//
//  Created by Cc on 14/12/9.
//  Copyright (c) 2014年 PinguoSDK. All rights reserved.
//

#import "NSBundle+CLOCommonCore.h"
#import "CLOLogHelper.h"

@implementation NSBundle (CLOCommonCore)

+ (NSBundle *)CLOBundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName
{
    if (bundleName == nil && podName == nil)
    {
        @throw @"bundleName和podName不能同时为空";
    }
    else if (bundleName == nil )
    {
        bundleName = podName;
    }
    else if (podName == nil)
    {
        podName = bundleName;
    }
    
    if ([bundleName containsString:@".bundle"])
    {
        bundleName = [bundleName componentsSeparatedByString:@".bundle"].firstObject;
    }
    //没使用framwork的情况下
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
    //使用framework形式
    if (!associateBundleURL)
    {
        associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
        associateBundleURL = [associateBundleURL URLByAppendingPathComponent:podName];
        associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
        NSBundle *associateBunle = [NSBundle bundleWithURL:associateBundleURL];
        associateBundleURL = [associateBunle URLForResource:bundleName withExtension:@"bundle"];
    }
    
    NSAssert(associateBundleURL, @"取不到关联bundle");
    //生产环境直接返回空
    return associateBundleURL?[NSBundle bundleWithURL:associateBundleURL]:nil;
}

@end
