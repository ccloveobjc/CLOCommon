//
//  CLONetworkingRequest.h
//  CLOCommon
//
//  Created by Cc on 2016/11/28.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLONetworkingObject.h"


@interface CLONetworkingRequest : NSObject

    @property (nonatomic) dispatch_semaphore_t sem;

    @property (nonatomic) CLONetworkingObject *mObjParam;

    @property (nonatomic,copy) bPgSdkCommonNetworkingDownload mBlock_Finish;

    @property (nonatomic,copy) bPgSdkCommonNetworkingDownloadProgress mBlock_Progress;

#ifdef DEBUG
    @property (nonatomic) NSString *mDebug_UUID;
#endif

@end
