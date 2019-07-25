//
//  pg_sdk_common_networking_object.m
//  pg_sdk_common
//
//  Created by Cc on 2016/11/28.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import "CLONetworkingObject.h"

@implementation CLONetworkingObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _mUrlPath = nil;
        _mEumHttpMethod = ePg_sdk_common_networking_method_post;
        _mDicParams = nil;
        _mBolAsycn = YES;
        _mFltTimeoutInterval = 30.0;
    }
    
    return self;
}

@end
