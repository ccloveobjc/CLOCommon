//
//  CLOPathHelper.m
//  CLOAlbum
//
//  Created by Cc on 2018/1/13.
//

#import "CLOPathHelper.h"

@implementation CLOPathHelper

+ (NSString *)sGetDocumentDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)sGetLibraryDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

@end
