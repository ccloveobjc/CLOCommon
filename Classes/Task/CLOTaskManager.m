//
//  CLOTaskManager.m
//  CLOCommon
//
//  Created by Cc on 16/5/14.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import "CLOTaskManager.h"
#import "CLOTaskTask.h"
#import "CLOTaskOperation.h"
#import <CLOCommon/CLOCommonCore.h>

@interface CLOTaskManager ()

// 线程名字
@property (nonatomic,strong) NSString *mStrThreadName;
@property (nonatomic,strong) NSThread *mFlowThread;
@property (nonatomic,strong) CLOSyncMutableArray<__kindof CLOTaskOperation *> *mArrFlowOperation;
@property (nonatomic, copy) bCLOCommonTaskFinish mStartBlock;
@property (nonatomic, copy) bCLOCommonTaskFinish mStopBlock;

@end
@implementation CLOTaskManager

/* 获取一个 Task */
+ (__kindof CLOTaskTask *)sGotTaskByClass:(Class)cls
{
    CLOTaskTask *task = nil;
    if ([cls isSubclassOfClass:[CLOTaskTask class]]) {
        
        task = [[cls alloc] init];
    }
    
    SDKAssertionLog(task, @"没有创建");
    return task;
}

/* 获取一个 Operation */
+ (CLOTaskOperation *)sGotNormalQueue:(__kindof CLOTaskTask *)task
                         withIdentify:(__kindof NSObject *)obj
{
    CLOTaskOperation *op = nil;
    
    if ([task isKindOfClass:[CLOTaskTask class]]) {
        
        op = [[CLOTaskOperation alloc] initWithTask:task withIdentify:obj];
    }
    
    SDKAssertionLog(op, @"没有创建");
    return op;
}

- (instancetype)init
{
    self = [self initWithThreadName:@""];
    
    /* 不能是直接调用 */
    SDKAssertionLog(NO, @"不能是直接调用");
    abort();
    
    return self;
}
- (instancetype)initWithThreadName:(NSString *)name
{
    self = [super init];
    if (self) {
        
        _mStrThreadName = name ? name : @"com.clo.clocommon_task_default";
        _mArrFlowOperation = [[CLOSyncMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
//    SDKLog(@"dealloc");
    self.mStartBlock = nil;
    self.mStopBlock = nil;
    self.mArrFlowOperation = nil;
}

- (void)pStart
{
    [self pStart:nil];
}
- (void)pStart:(bCLOCommonTaskFinish)block
{
    self.mStartBlock = block;
    if (!self.mFlowThread) {
        
        @synchronized (self) {
            
            if (!self.mFlowThread) {
                
                self.mFlowThread = [[NSThread alloc] initWithTarget:self selector:@selector(onFlowThread) object:nil];
                self.mFlowThread.name = self.mStrThreadName;
                [self.mFlowThread start];
            }
        }
    }
}

- (void)pStop
{
    [self pStop:nil];
}
- (void)pStop:(bCLOCommonTaskFinish)block
{
    self.mStopBlock = block;
    if (self.mFlowThread) {
        
        @synchronized (self) {
            
            [self.mFlowThread cancel];
            self.mFlowThread = nil;
        }
    }
}

/* 插入任务 */
- (void)pInsertOperation:(CLOTaskOperation *)queue
{
//    SDKLog(@"插入任务 pInsertOperation:");
    
    [queue.mOperationTask onInit];
    [self.mArrFlowOperation pAddObject:queue];
}

- (void)pStopCurrentOperationAndInsert:(__kindof CLOTaskOperation *)queue
{
    if (self.mArrFlowOperation.mStashObject) {
        
//        SDKLog(@"停止当前任务 pStopCurrentOperationAndInsert:");
        [self.mArrFlowOperation.mStashObject pCancel];
    }
    
    if (queue) {
        
        [self pInsertOperation:queue];
    }
}

- (void)onFlowThread
{
    if (self.mStartBlock) {
        
        self.mStartBlock(YES);
    }
    
    do {
        
        CLOTaskOperation *op = [self.mArrFlowOperation pGotStashObject];
        if (op) {
            
            op.mOperationTask.meTaskStatus = eCLOTaskStatusInit;
            [op main];
            switch (op.meOperationStatus) {
                    
                case eCLOTaskStatusCancel: {
                    
                    if (!op.mIsThrowForCancel) {
                        
                        [self.mArrFlowOperation pAddObject:op];
                    }
                }
                    break;
                case eCLOTaskStatusComplete: {
                    
//                    SDKLog(@"任务完成 ePGWorkflowStatus_complete");
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        [NSThread sleepForTimeInterval:0.01f];
        //Cc: 永不结束，永不停止，人在塔在！看情况嘛！
    } while (![[NSThread currentThread] isCancelled]);
    
    if (self.mStopBlock) {
        
        self.mStopBlock(YES);
    }
}

@end
