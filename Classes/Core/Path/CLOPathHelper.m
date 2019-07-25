//
//  CLOPathHelper.m
//  CLOCommon
//
//  Created by Cc on 2018/1/13.
//

#import "CLOPathHelper.h"

@implementation CLOPathHelper

+ (NSString *)getDocumentDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)getLibraryDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

@end
