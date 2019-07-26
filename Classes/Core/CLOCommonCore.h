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

#define CLODeprecated               DEPRECATED_ATTRIBUTE
#define CLODesignatedInitializer    NS_DESIGNATED_INITIALIZER
#define CLOTargetIphoneSimulator    TARGET_IPHONE_SIMULATOR

#import <CLOCommon/CLOBlockHelper.h>
#import <CLOCommon/CLOLogHelper.h>
#import <CLOCommon/CLOPathHelper.h>

#import <CLOCommon/CLOSize.h>

#import <CLOCommon/NSArray+CLOCommonCore.h>
#import <CLOCommon/NSData+CLOConvertToHex.h>
#import <CLOCommon/NSDictionary+CLOCommonCore.h>
#import <CLOCommon/NSError+CLOCommonCore.h>
#import <CLOCommon/NSFileManager+CLOCommonCoreicloud.h>
#import <CLOCommon/NSMutableData+CLOCommonCoreArchiver.h>
#import <CLOCommon/NSObject+CLOCommonCore.h>
#import <CLOCommon/NSSet+CLOCommonCore.h>
#import <CLOCommon/NSString+CLOCommonCore.h>
#import <CLOCommon/NSThread+CLOCommonCore.h>

#import <CLOCommon/CLOSyncMutableArray.h>
#import <CLOCommon/CLOSyncMutableDictionary.h>
