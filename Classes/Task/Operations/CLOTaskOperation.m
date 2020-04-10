//
//  CLOTaskOperation.m
//  CLOCommon
//
//  Created by Cc on 16/5/24.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import "CLOTaskOperation.h"
#import "CLOTaskTask.h"
#import <CLOCommon/CLOCommonCore.h>

@interface CLOTaskOperation ()

    @property (atomic,assign) BOOL mIsThrowForCancel;

@end
@implementation CLOTaskOperation

- (eCLOTaskStatus)meOperationStatus
{
    return self.mOperationTask.meTaskStatus;
}

- (instancetype)init
{
    self = [self initWithTask:[[CLOTaskTask alloc] init] withIdentify:nil];
    
    /* 不允许直接调用 */
    SDKAssertionLog(NO, @"不允许直接调用 使用 - initWithTask: withIdentify:");
    abort();
    
    return self;
}

- (instancetype)initWithTask:(__kindof CLOTaskTask *)task withIdentify:(nullable __kindof NSObject *)identify
{
    if (task) {
        
        self = [super init];
        if (self)
        {
            _mIsThrowForCancel = NO;
            _mOperationTask = task;
            _mIdentify = identify;
        }
        
        return self;
    }
    
    return nil;
}

- (void)dealloc
{
//    SDKLog(@"dealloc");
}

- (void)main
{
    [self.mOperationTask pRunning];
}

- (void)pCancel
{
    self.mOperationTask.meTaskStatus = eCLOTaskStatusCancel;
}

- (void)pCancelAndThrow
{
    self.mIsThrowForCancel = YES;
    [self pCancel];
}

@end
