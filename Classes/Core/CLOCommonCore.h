//
//  CLOCommonCore.h
//  CLOCommonCore
//
//  Created by Cc on 15/12/11.
//  Copyright © 2015年 PinguoSDK. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for CLOCommonCore.
FOUNDATION_EXPORT double CLOCommonCoreVersionNumber;

//! Project version string for CLOCommonCore.
FOUNDATION_EXPORT const unsigned char CLOCommonCoreVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CLOCommon/PublicHeader.h>

#define weakify(x) autoreleasepool{} __weak __typeof__(x) x##_weak = x;
#define strongify(x) autoreleasepool{} __strong __typeof__(x) x##_weak = x;

#import <CLOCommon/CLOLogMgr.h>

#import <CLOCommon/CLOPathHelper.h>
