//
//  NSThread+CLOCommonCore.m
//  CLOCommon
//
//  Created by Cc on 15/11/13.
//

#import "NSThread+CLOCommonCore.h"

@implementation NSThread (CLOCommonCore)

+ (void)CLOSyncToMain:(dispatch_block_t)block
{
    if (block) {
        
        if ([NSThread isMainThread]) {
            
            block();
        }
        else {
            
            dispatch_sync(dispatch_get_main_queue(), block);
        }
    }
}
@end
