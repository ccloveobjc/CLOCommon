//
//  CLOTaskTask.m
//  CLOCommon
//
//  Created by Cc on 16/5/24.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import "CLOTaskTask.h"
#import "CLOTaskStep.h"

@implementation CLOTaskTask

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _meTaskStatus = eCLOTaskStatusInit;
    }
    
    return self;
}

- (void)pSetupSteps:(NSArray<__kindof CLOTaskStep *> *)steps
{
    _mArrSteps = steps;
    for (CLOTaskStep *step in _mArrSteps)
    {
        step.mDelegate = self;
    }
}

- (void)pRunning
{
    self.meTaskStatus = eCLOTaskStatusRunning;
    
    for (CLOTaskStep *step in self.mArrSteps)
    {
        // 插桩
        if ([self dgTask_step_isCancel])
        {
            self.meTaskStatus = eCLOTaskStatusCancel;
            return;
        }
        
        // 任务开始
        {
            CLOTaskStepStatus bState = [step onGotTaskModel];
            switch (bState)
            {
                case CLOTaskStepStatusSuccess:
                {
                    bState = [step onMake];
                    switch (bState)
                    {
                        case CLOTaskStepStatusSuccess:
                        {
                            bState = [step onSetupTaskModel];
                            switch (bState)
                            {
                                case CLOTaskStepStatusCancel:
                                {
                                    self.meTaskStatus = eCLOTaskStatusCancel;
                                    return;
                                }
                                    break;
                                    
                                case CLOTaskStepStatusError:
                                {
                                    self.meTaskStatus = eCLOTaskStatusError;
                                    return;
                                }
                                    break;
                                    
                                case CLOTaskStepStatusSuccess:
                                {
                                    //运行下去
                                }
                                    break;
                                    
                                default:
                                    NSAssert(NO, @"没有实现新的枚举");
                                    break;
                            }
                        }
                            break;
                            
                        case CLOTaskStepStatusCancel:
                        {
                            self.meTaskStatus = eCLOTaskStatusCancel;
                            return;
                        }
                            break;
                            
                        case CLOTaskStepStatusError:
                        {
                            self.meTaskStatus = eCLOTaskStatusError;
                            return;
                        }
                            break;
                            
                        default:
                            NSAssert(NO, @"没有实现新的枚举， 或者不能是 ePGWorkflowStepStatus_break");
                            break;
                    }
                }
                    break;
                    
                case CLOTaskStepStatusCancel:
                {
                    self.meTaskStatus = eCLOTaskStatusCancel;
                    return;
                }
                    break;
                    
                case CLOTaskStepStatusError:
                {
                    self.meTaskStatus = eCLOTaskStatusError;
                    return;
                }
                    break;
                    
                case CLOTaskStepStatusBreak:
                {
                    // 什么都不用做，等着step 结束
                }
                    break;
                    
                default:
                    NSAssert(NO, @"没有实现新的枚举");
                    break;
            }
        };
        // 任务结束
    };
    
    self.meTaskStatus = eCLOTaskStatusComplete;
}

- (void)onInit
{
    // 不需要做事
}

- (BOOL)dgTask_step_isCancel
{
    return self.meTaskStatus == eCLOTaskStatusCancel;
}

@end
