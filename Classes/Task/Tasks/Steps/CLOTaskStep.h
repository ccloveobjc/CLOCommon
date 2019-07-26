//
//  pg_sdk_common_task_step.h
//  pg_sdk_common
//
//  Created by Cc on 16/5/24.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLOTaskInterface.h"
#import "CLOTaskStepDelegate.h"


    @class CLOTaskModel;


/* 判断是否取消了任务 */
#define kPGWF_isCancel if ([self pIsCancel]) \
{ \
    return ePGWorkflowStepStatus_cancel; \
}

@interface CLOTaskStep : NSObject
<
    CLOTaskInterface
>

/* 回调对象，查询是否cancel了任务等等逻辑，放这里 */
@property (nonatomic) id<CLOTaskStepDelegate> mDelegate;

/* 数据源 */
@property (nonatomic) __kindof CLOTaskModel *mStepModel;


- (instancetype)initWithModel:(CLOTaskModel *)model
               withInputBlock:(PGWorkflowBlockInput)input
              withOutputBlock:(PGWorkflowBlockOutput)output;


/**
 *  开始跑一个step作业
 *  里面应该需要插桩判定是否已经取消   用这个方法        - (BOOL)pIsCancel
 *
 *      CLOTaskStepStatusSuccess   表示成功
 *      CLOTaskStepStatusError         表示失败了
 *      CLOTaskStepStatusCancel        表示取消了
 *      CLOTaskStepStatusBreak       不能出现
 */
- (CLOTaskStepStatus)onMake;


/* 判断是否已经取消  如果判定为真，应该在onMake方法中返回 CLOTaskStepStatusCancel */
- (BOOL)pIsCancel;

@end
