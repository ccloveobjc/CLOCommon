//
//  pg_sdk_common_sync_mutable_array.h
//  pg_sdk_common
//
//  Created by Cc on 16/5/24.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLOSyncMutableArray<ObjectType> : NSObject

    @property (nonatomic,strong) ObjectType mStashObject;

/**
 *  ［线程安全］添加一个对象
 */
- (void)pAddObject:(ObjectType)obj;

/**
 *  ［线程安全］获取第一个对象
 */
- (id)pGotStashObject;

/**
 *  ［线程安全］删除一个对象
 */
- (void)pRemoveObject:(ObjectType)obj;

@end
