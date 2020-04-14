//
//  CLONetworkingHelper.h
//  CLOCommon
//
//  Created by Cc on 2016/11/28.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLONetworkingObject.h"

@interface CLONetworkingHelper : NSObject

- (instancetype)init;
- (instancetype)initWithQueue:(NSOperationQueue *)queue;

- (void)pRequest:(CLONetworkingObject *)postParam withFinish:(bCLONetworkingFinish)block;

- (void)pRequestDownload:(CLONetworkingObject *)postParam
              withFinish:(bCLONetworkingDownload)block
            withProgress:(bCLONetworkingDownloadProgress)progress;


- (void)pRequest:(CLONetworkingObject *)postParam
      withFinish:(bCLONetworkingFinish)block
    withProgress:(bCLONetworkingDownloadProgress)progress;

@end
