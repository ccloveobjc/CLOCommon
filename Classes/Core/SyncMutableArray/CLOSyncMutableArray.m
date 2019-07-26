//
//  pg_sdk_common_sync_mutable_array.m
//  pg_sdk_common
//
//  Created by Cc on 16/5/24.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import "CLOSyncMutableArray.h"

@interface CLOSyncMutableArray ()

    @property (nonatomic,strong) NSMutableArray *mArrObjs;

@end

@implementation CLOSyncMutableArray

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _mArrObjs = [NSMutableArray array];
    }
    
    return self;
}

- (void)pAddObject:(id)obj
{
    @synchronized (self) {
        
        [self.mArrObjs addObject:obj];
    }
}

- (id)pGotStashObject
{
    @synchronized (self) {
        
        self.mStashObject = nil;
        
        if (self.mArrObjs.count > 0) {
            
            self.mStashObject = self.mArrObjs[0];
            [self pRemoveObject:self.mStashObject];
        }
        
        return self.mStashObject;
    }
}

- (void)pRemoveObject:(id)obj
{
    @synchronized (self) {
        
        [self.mArrObjs removeObject:self.mStashObject];
    }
}

@end
