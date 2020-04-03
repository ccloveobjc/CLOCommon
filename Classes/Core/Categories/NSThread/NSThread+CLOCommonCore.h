//
//  NSThread+CLOCommonCore.h
//  CLOCommon
//
//  Created by Cc on 15/11/13.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSThread (CLOCommonCore)

+ (void)CLOSyncToMain:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
