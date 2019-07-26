//
//  pg_sdk_common_task_step.m
//  pg_sdk_common
//
//  Created by Cc on 16/5/24.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import "CLOTaskStep.h"
#import "CLOTaskModel.h"

@interface CLOTaskStep ()

    /* 设置参数的block回调 */
    @property (nonatomic,copy) PGWorkflowBlockInput mInputBlock;

    /* 返回参数的block回调 */
    @property (nonatomic,copy) PGWorkflowBlockOutput mOutputBlock;

@end
@implementation CLOTaskStep

- (instancetype)initWithModel:(CLOTaskModel *)model
               withInputBlock:(PGWorkflowBlockInput)input
              withOutputBlock:(PGWorkflowBlockOutput)output
{
    self = [super init];
    if (self)
    {
        _mStepModel = model;
        self.mInputBlock = input;
        self.mOutputBlock = output;
    }
    
    return self;
}

- (CLOTaskStepStatus)onGotTaskModel
{
    if (self.mInputBlock) {
        
        return self.mInputBlock(self.mStepModel);
    }
    
    return CLOTaskStepStatusSuccess;
}

- (CLOTaskStepStatus)onSetupTaskModel
{
    if (self.mOutputBlock) {
        
        return self.mOutputBlock(self.mStepModel);
    }
    
    return CLOTaskStepStatusSuccess;
}

- (CLOTaskStepStatus)onMake
{
    NSAssert(NO, @"子类必须实现");
    return CLOTaskStepStatusError;
}

- (BOOL)pIsCancel
{
    if (self.mDelegate && [self.mDelegate respondsToSelector:@selector(dgTask_step_isCancel)])
    {
        return [self.mDelegate dgTask_step_isCancel];
    }
    else
    {
        NSAssert(NO, @"");
    }
    
    return NO;
}

@end
