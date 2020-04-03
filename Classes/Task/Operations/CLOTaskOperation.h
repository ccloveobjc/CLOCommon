//
//  CLOTaskOperation.h
//  CLOCommon
//
//  Created by Cc on 16/5/24.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import "CLOTaskInterface.h"


    @class CLOTaskTask;


NS_ASSUME_NONNULL_BEGIN

@interface CLOTaskOperation : NSOperation

    /* 使用Task的状态 */
    @property (atomic,assign,readonly) eCLOTaskStatus meOperationStatus;

    /* 是否cancel之后丢弃掉 */
    @property (atomic,assign,readonly) BOOL mIsThrowForCancel;

    /* 任务流程 */
    @property (nonatomic,strong,readonly) __kindof CLOTaskTask *mOperationTask;

    /* 唯一码 */
    @property (nullable,nonatomic,strong,readonly) __kindof NSObject *mIdentify;

/* 初始化 */
- (instancetype)initWithTask:(__kindof CLOTaskTask *)task
                withIdentify:(nullable __kindof NSObject *)identify NS_DESIGNATED_INITIALIZER;


/* 取消当前，并插入到第一个位置 */
- (void)pCancel;

/* 取消当前，并丢弃 */
- (void)pCancelAndThrow;

@end

NS_ASSUME_NONNULL_END
