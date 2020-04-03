//
//  CLOTaskInterface.h
//  CLOCommon
//
//  Created by Cc on 16/5/14.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import <Foundation/Foundation.h>


    @class CLOTaskModel;


/* step 的状态 */
typedef NS_ENUM(NSUInteger, CLOTaskStepStatus)
{
    /* 任务完成，如果没有错误，就返回这个值 */
    CLOTaskStepStatusSuccess,
    
    /* 任务取消，中途想停止，使用这个值*/
    CLOTaskStepStatusCancel,
    
    /* 任务中途有错误，终止任务*/
    CLOTaskStepStatusError,
    
    /* 任务跳过，如果 onGotTaskModel 返回这个值，表示这个step不做，不会调用 onSetupTaskModel , 只能在 onGotTaskModel 中返回这个值 */
    CLOTaskStepStatusBreak,
};

/* task 流程的状态 */
typedef NS_ENUM(NSUInteger, eCLOTaskStatus)
{
    /* 初始化 */
    eCLOTaskStatusInit,
    
    /* 正在执行任务当中 */
    eCLOTaskStatusRunning,
    
    /* 取消了此次任务 */
    eCLOTaskStatusCancel,
    
    /* 执行任务时发生错误 */
    eCLOTaskStatusError,
    
    /* 任务完成 */
    eCLOTaskStatusComplete,
};


/* 一个任务开始时会调用 */
typedef CLOTaskStepStatus (^PGWorkflowBlockInput)(__kindof CLOTaskModel *inputModel);

/* 一个任务结束时会调用 */
typedef CLOTaskStepStatus (^PGWorkflowBlockOutput)(__kindof CLOTaskModel *outputModel);



/* 任务相关接口 */
@protocol CLOTaskInterface <NSObject>

/* 获取数据源 设置input参数 */
- (CLOTaskStepStatus)onGotTaskModel;

/* 设置数据源 设置output参数 */
- (CLOTaskStepStatus)onSetupTaskModel;

@end
