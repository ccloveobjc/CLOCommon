//
//  CLOSyncMutableDictionary.m
//  CLOCommon
//
//  Created by Cc on 16/8/10.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import "CLOSyncMutableDictionary.h"
#import "CLOLogHelper.h"

@interface CLOSyncMutableDictionary ()

    @property (nonatomic,strong) NSMutableDictionary *mDicObjs;

@end

@implementation CLOSyncMutableDictionary

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _mDicObjs = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (NSUInteger)mCount
{
    @synchronized (_mDicObjs) {
        
        return _mDicObjs.count;
    }
}

/**
 *  ［线程安全］添加一个对象
 */
- (void)pSetupObject:(id)obj withKey:(id)key
{
    if (key && obj) {
        
        @synchronized (_mDicObjs) {
            
            _mDicObjs[key] = obj;
        }
    }
    SDKAssertElseLog(@"");
}

/**
 *  ［线程安全］获取一个对象
 */
- (id)pGotObjectForKey:(id)key
{
    if (key) {
        
        @synchronized (_mDicObjs) {
            
            return _mDicObjs[key];
        }
    }
    SDKAssertElseLog(@"");
    
    return nil;
}

/**
 *  ［线程安全］删除一个对象
 */
- (void)pRemoveObject:(id)key
{
    if (key) {
        
        @synchronized (_mDicObjs) {
            
            [_mDicObjs removeObjectForKey:key];
        }
    }
    SDKAssertElseLog(@"");
}


- (id)pGotFirstObject
{
    @synchronized (_mDicObjs) {
        
        return _mDicObjs.allValues.firstObject;
    }
}

@end
