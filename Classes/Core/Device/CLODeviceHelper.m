//
//  CLODeviceHelper.m
//  CLOCommon
//
//  Created by Cc on 2019/8/5.
//

#import "CLODeviceHelper.h"

@implementation CLODeviceHelper

- (NSString *)gotIdentifierForVendor
{
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

@end
