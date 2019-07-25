//
//  NSFileManager+CLOCommonCoreicloud.h
//  CLOCommon
//  
//  Created by Cc on 14-12-3.
//


#import "NSFileManager+CLOCommonCoreicloud.h"
#import "CLOLogHelper.h"

@implementation NSFileManager (CLOCommonCoreicloud)

- (BOOL)CLOAddSkipBackupAttributeToItemAtFilePath:(NSString *)filePath
{
    if ([filePath isKindOfClass:[NSString class]]) {
        
        NSURL *URL;
        if ([filePath hasPrefix:@"file://"]) {
            
            URL = [NSURL URLWithString:filePath];
        }
        else {
            
            URL = [NSURL fileURLWithPath:filePath];
        }
        const BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[URL path]];
        if (isExist) {
            
            NSError *error = nil;
            BOOL success = [URL setResourceValue:@YES
                                          forKey:NSURLIsExcludedFromBackupKey
                                           error:&error];
            if (!success)
            {
                SDKErrorLog(@"setResourceValue : %@", error);
            }
            
            return YES;
        }
        else {
            
            SDKErrorLog(@"fileExistsAtPath = NO");
        }
    }
    else {
        
        SDKErrorLog(@"filePath != NSString");
    }
    
    return NO;
}

@end
