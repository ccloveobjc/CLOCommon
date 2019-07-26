//
//  pg_sdk_common_sync_mutable_dictionary.h
//  pg_sdk_common
//
//  Created by Cc on 16/8/10.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLOSyncMutableDictionary<ObjectTypeKey, ObjectTypeValue> : NSObject


    @property (nonatomic,assign,readonly) NSUInteger mCount;

/**
 *  ［线程安全］添加一个对象
 */
- (void)pSetupObject:(ObjectTypeValue)obj withKey:(ObjectTypeKey)key;

/**
 *  ［线程安全］获取一个对象
 */
- (ObjectTypeValue)pGotObjectForKey:(ObjectTypeKey)key;

/**
 *  ［线程安全］删除一个对象
 */
- (void)pRemoveObject:(ObjectTypeKey)key;

/**
 [ 线程安全 ] 获取第一个对象
 */
- (ObjectTypeValue)pGotFirstObject;

@end
