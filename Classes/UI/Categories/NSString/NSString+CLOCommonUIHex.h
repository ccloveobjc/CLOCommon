//
//  NSString+CLOCommonUIHex.h
//  CLOCommon
//
//  Created by Cc on 16/6/2.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CLOCommonUIHex)

- (BOOL)CLOGotColorWithOutR:(NSUInteger *)oR
                   withOutG:(NSUInteger *)oG
                   withOutB:(NSUInteger *)oB;

@end

NS_ASSUME_NONNULL_END
