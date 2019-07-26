//
//  pg_sdk_common_task_delegate.h
//  pg_sdk_common
//
//  Created by Cc on 16/5/24.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CLOTaskStepDelegate <NSObject>

/* 是否取消了，用的回调模式 */
- (BOOL)dgTask_step_isCancel;

@end
