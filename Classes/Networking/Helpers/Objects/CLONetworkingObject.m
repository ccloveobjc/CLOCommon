//
//  CLONetworkingObject.m
//  CLOCommon
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
        _mDicParams = nil;
        _mDicHeaders = nil;
        _mEumHttpMethod = eCLONetworkingMethod_POST;
        _mEumContentType = eCLONetworkingContentType_Text;
        _mBolAsycn = YES;
        _mFltTimeoutInterval = 30.0;
    }
    
    return self;
}

@end
