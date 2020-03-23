//
//  pg_sdk_common_networking_object.h
//  pg_sdk_common
//
//  Created by Cc on 2016/11/28.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

    typedef void (^bCLONetworkingFinish)(NSData *data, NSURLResponse *response, NSError *err);

    typedef void (^bCLONetworkingDownload)(NSURL * location, NSURLResponse * response, NSError * err);

    typedef void (^bCLONetworkingDownloadProgress)(int64_t location, int64_t dataLenght);


    typedef NS_ENUM(NSUInteger, eCLONetworkingMethod) {
        /* Post */
        eCLONetworkingMethod_POST = 0,
        /* Get */
        eCLONetworkingMethod_GET,
    };

@interface CLONetworkingObject : NSObject

    /** URL  default = nil*/
    @property (nonatomic,strong) NSURL *mUrlPath;

    /** URL  default = nil*/
    @property (nonatomic,strong) NSDictionary<NSString *, NSString *> *mDicParams;

    /** default = POST */
    @property (nonatomic,assign) eCLONetworkingMethod mEumHttpMethod;

    /** 是否异步，default = YES */
    @property (nonatomic,assign) BOOL mBolAsycn;

    /** 超时时间 单位s  default = 30s*/
    @property (nonatomic,assign) NSTimeInterval mFltTimeoutInterval;

@end
