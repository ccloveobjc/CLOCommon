//
//  CLOTaskTask.h
//  CLOCommon
//
//  Created by Cc on 16/5/24.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import "CLOTaskInterface.h"
#import "CLOTaskStepDelegate.h"


    @class CLOTaskStep;


@interface CLOTaskTask : NSObject
<
    CLOTaskStepDelegate
>

    /* 当前task 的状态*/
    @property (atomic,assign) eCLOTaskStatus meTaskStatus;

    /* 当前task步骤流*/
    @property (nonatomic,strong,readonly) NSArray<__kindof CLOTaskStep *> *mArrSteps;


/* 设置步骤 */
- (void)pSetupSteps:(NSArray<__kindof CLOTaskStep *> *)steps;


/* 跑起走 */
- (void)pRunning;


/* 初始化，当调用 pInsertOperation 时触发 */
- (void)onInit;

@end
