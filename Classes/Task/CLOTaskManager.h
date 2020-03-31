//
//  pg_sdk_common_task_manager.h
//  pg_sdk_common
//
//  Created by Cc on 16/5/14.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import <Foundation/Foundation.h>


    @class CLOTaskTask;
    @class CLOTaskOperation;

typedef void (^bCLOCommonTaskFinish)(BOOL);

NS_ASSUME_NONNULL_BEGIN
/**
 *  帮助任务管理
 */
@interface CLOTaskManager : NSObject

    /** CPU使用率达到这个值，将停止对列执行 [ 默认0 无限制 ] */
    @property (nonatomic,strong) NSNumber *mCPU; // TODO: 没有实现

    /* 获取一个 Task */
    + (__kindof CLOTaskTask *)sGotTaskByClass:(Class)cls;

    /* 获取一个 Operation */
    + (CLOTaskOperation *)sGotNormalQueue:(__kindof CLOTaskTask *)task
                             withIdentify:(nullable __kindof NSObject *)obj;


/** 只能使用这个进行初始化 */
- (instancetype)initWithThreadName:(NSString *)name NS_DESIGNATED_INITIALIZER;

/** 开始任务队列循环执行 */
- (void)pStart;
- (void)pStart:(nullable bCLOCommonTaskFinish)block;

/** 结束任务队列循环执行，如果需要销毁本实例，需要调用这个接口后再设置 nil */
- (void)pStop;
- (void)pStop:(nullable bCLOCommonTaskFinish)block;

/** 插入任务 */
- (void)pInsertOperation:(__kindof CLOTaskOperation *)queue;

/** 停止当前正在做的任务，并追加到队前 */
- (void)pStopCurrentOperationAndInsert:(__kindof CLOTaskOperation *)queue;

@end
NS_ASSUME_NONNULL_END
