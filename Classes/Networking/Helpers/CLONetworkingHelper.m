//
//  CLONetworkingHelper.m
//  CLOCommon
//
//  Created by Cc on 2016/11/28.
//  Copyright © 2016年 PinguoSDK. All rights reserved.
//

#import "CLONetworkingHelper.h"
#import "CLONetworkingRequest.h"
#import <CLOCommon/CLOCommonCore.h>
#import <CLOCommon/CLOCommonJson.h>

@interface CLONetworkingHelper ()
<
    NSURLSessionDelegate
    , NSURLSessionDataDelegate
    , NSURLSessionDownloadDelegate
>

    @property (nonatomic,strong) NSURLSession *mSession;
    @property (nonatomic,strong) NSOperationQueue *mOQueue;
    @property (nonatomic,strong) NSMutableDictionary<NSString *, CLONetworkingRequest *> *mDicKeyObj;

@end

@implementation CLONetworkingHelper

- (instancetype)init
{
    self = [self initWithQueue:nil];
    if (self) {
        
        abort();// 换 initWithQueue 来用
    }
    
    return self;
}

- (instancetype)initWithQueue:(NSOperationQueue *)queue
{
    self = [super init];
    if (self) {
        
        if (queue) {
            
            _mOQueue = queue;
        }
        else {
            
            _mOQueue = [[NSOperationQueue alloc] init];
            _mOQueue.name = [@"com.ccloveobjc.networking." stringByAppendingString:[NSUUID UUID].UUIDString];
        }
        
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        __weak id  d = self;
        __weak id  dq = _mOQueue;
//        _mSession = [NSURLSession sessionWithConfiguration:configuration delegate:d delegateQueue:dq];
        _mSession = [NSURLSession sessionWithConfiguration:configuration];
        
        _mDicKeyObj = [NSMutableDictionary dictionary];
    }
    
    return self;
}


- (void)dealloc
{
    SDKLog(@"dealloc");
}

- (void)pRequest:(CLONetworkingObject *)postParam withFinish:(bCLONetworkingFinish)block
{
    abort();
    NSURL *url = postParam.mUrlPath;
    NSDictionary<NSString *, NSString *> *params = postParam.mDicParams;
    BOOL isAsycn = postParam.mBolAsycn;
    
    if (url) {
        
        NSMutableURLRequest *request = nil;
        NSString *strBody = [self fGotParamsStringByDictionary:params];
        if (postParam.mEumHttpMethod == eCLONetworkingMethod_GET)
        {
            NSString *strNUrl = [[NSString alloc] initWithFormat:@"%@?%@", url, strBody];
            NSURL *nUrl = [NSURL URLWithString:strNUrl];
            request = [[NSMutableURLRequest alloc] initWithURL:nUrl];
            request.HTTPMethod = @"GET";
        }
        else
        {
            request = [[NSMutableURLRequest alloc] initWithURL:url];
            request.HTTPMethod = @"POST";
            request.HTTPBody = [strBody dataUsingEncoding:NSUTF8StringEncoding];
        }
        request.timeoutInterval = postParam.mFltTimeoutInterval;
        
        // 如果有header 添加
        NSDictionary *headers = postParam.mDicHeaders;
        if (headers)
        {
            for (int ir = 0; ir < headers.allKeys.count; ir ++) {
                
                NSString *iKey = headers.allKeys[ir];
                NSString *iValue = headers[iKey];
                [request setValue:iValue forHTTPHeaderField:iKey];
            }
        }
        
        NSURLSessionTask *cTask = nil;
        dispatch_semaphore_t sem = nil;
        
        if (!isAsycn) {
            
            SDKLog(@"!! < dispatch_semaphore_create > !!")
            sem = dispatch_semaphore_create(0);
        }
        
#if DEBUG
        NSString *keyUUID = [NSUUID UUID].UUIDString;
#endif
        
        SDKLog(@"[%@] <%@> 请求 url:%@  params:%@", request.HTTPMethod, keyUUID, url, params)
        cTask = [self.mSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            SDKLog(@"[%@] <%@> 收到数据 %@ string = %@"
                   , request.HTTPMethod
                   , keyUUID
                   , @(data.length)
                   , [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding])
            
            if (block) {
                
                block(data, response, error);
            }
            
            if (!isAsycn) {
                
                SDKLog(@"!! < dispatch_semaphore_signal > !!")
                dispatch_semaphore_signal(sem);
            }
        }];
        
        if (cTask) {
            
            SDKLog(@"开启任务[%@]", @(cTask.taskIdentifier));
            [cTask resume];
            
            if (!isAsycn) {
                
                SDKLog(@"!! < dispatch_semaphore_wait > !!")
                dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
            }
        }
        else {
            
            SDKAssert
            if (block) {
                
                
                block(nil, nil, CLOErrorMake(@"CLOCommon", -404, @"参数错误"));
            }
        }
    }
    else {
        
        if (block) {
            
            block(nil, nil, CLOErrorMake(@"CLOCommon", -404, @"参数错误"));
        }
        SDKAssertionLog(NO, @"URL 为空");
    }
}

- (void)pRequestDownload:(CLONetworkingObject *)postParam
              withFinish:(bCLONetworkingDownload)finish
            withProgress:(bCLONetworkingDownloadProgress)progress
{
    abort();
    NSURL *url = postParam.mUrlPath;
    NSDictionary<NSString *, NSString *> *params = postParam.mDicParams;
    BOOL isAsycn = postParam.mBolAsycn;
    
    if (url) {
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        {
            NSString *strBody = [self fGotParamsStringByDictionary:params];
            request.HTTPMethod = postParam.mEumHttpMethod == eCLONetworkingMethod_GET ? @"GET" : @"POST";
            request.HTTPBody = [strBody dataUsingEncoding:NSUTF8StringEncoding];
            request.timeoutInterval = postParam.mFltTimeoutInterval;
        }
        
        
        
        NSURLSessionTask *cTask = nil;
        dispatch_semaphore_t sem = nil;
        
        if (!isAsycn) {
            
            SDKLog(@"!! < dispatch_semaphore_create > !!")
            sem = dispatch_semaphore_create(0);
        }
        
#if DEBUG
        NSString *keyUUID = [NSUUID UUID].UUIDString;
#endif
        
        SDKLog(@"[%@] <%@> 请求 url:%@  params:%@", request.HTTPMethod, keyUUID, url, params)
        
        cTask = [self.mSession downloadTaskWithRequest:request];
        
        if (self.mDicKeyObj) {
            
            @synchronized (self.mDicKeyObj) {
                
                CLONetworkingRequest *keyObj = [[CLONetworkingRequest alloc] init];
                {
                    keyObj.sem = sem;
                    keyObj.mObjParam = postParam;
                    keyObj.mBlock_Finish = finish;
                    keyObj.mBlock_Progress = progress;
#ifdef DEBUG
                    keyObj.mDebug_UUID = keyUUID;
#endif
                }
                NSString *key = [[NSString alloc] initWithFormat:@"%@", @(cTask.taskIdentifier)];
                self.mDicKeyObj[key] = keyObj;
                SDKLog(@"设置 mDicKeyObj[%@] = %@", key, keyObj);
            }
        }
        SDKAssertElseLog(@"");
        
        if (cTask) {
            
            [cTask resume];
            
            if (!isAsycn) {
                
                SDKLog(@"!! < dispatch_semaphore_wait > !!")
                dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
            }
        }
        else {
            
            SDKAssert
            if (finish) {
                
                finish(nil, nil, CLOErrorMake(@"CLOCommon", -404, @"参数错误"));
            }
        }
    }
    else {
        
        SDKAssert
        if (finish) {
            
            finish(nil, nil, CLOErrorMake(@"CLOCommon", -404, @"参数错误"));
        }
    }
}

- (NSString *)fGotParamsStringByDictionary:(NSDictionary<NSString *, NSString *> *)dicParams
{
    NSMutableString *strParams = [[NSMutableString alloc] initWithString:@""];
    
    if (dicParams) {
        
        if ([dicParams isKindOfClass:[NSDictionary class]]) {
            
            BOOL isFirst = YES;
            for (NSString *key in dicParams.allKeys) {
                
                if (isFirst) {
                    
                    isFirst = NO;
                }
                else {
                    
                    [strParams appendString:@"&"];
                }
                
                [strParams appendFormat:@"%@=%@", key, [dicParams[key] CLOEncodeToWebSafeEscapeString]];
            }
        }
        else {
            
            SDKAssert
        }
    }
    
    return strParams;
}

- (void)vGotRequestByTask:(NSURLSessionTask *)task withLocation:(NSURL *)location withError:(NSError *)err
{
    CLONetworkingRequest *keyObj = nil;
    NSString *key = [[NSString alloc] initWithFormat:@"%@", @(task.taskIdentifier)];
    if (key) {
        
        @synchronized (self.mDicKeyObj) {
            
            keyObj = self.mDicKeyObj[key];
            if (!keyObj) {
                
                return;
            }
            
            [self.mDicKeyObj removeObjectForKey:key];
            SDKLog(@"删除 mDicKeyObj[%@]", key);
        }
    }
    SDKAssertElseLog(@"");
    
    if (keyObj) {
        
#ifdef DEBUG
        NSString *keyUUID = keyObj.mDebug_UUID;
#endif
        SDKLog(@"[%@] <%@> 收到数据 URL = %@", task.currentRequest.HTTPMethod, keyUUID, location);
        
        if (keyObj.mBlock_Finish) {
            
            keyObj.mBlock_Finish(location, task.response, err);
        }
        
        if (!keyObj.mObjParam.mBolAsycn) {
            
            SDKLog(@"!! < dispatch_semaphore_signal > !!")
            if (keyObj.sem) {
                
                dispatch_semaphore_signal(keyObj.sem);
            }
        }
    }
}

- (void)pRequest:(CLONetworkingObject *)postParam
      withFinish:(bCLONetworkingFinish)block
    withProgress:(bCLONetworkingDownloadProgress)progress
{
    NSURL *url = postParam.mUrlPath;
    NSDictionary<NSString *, NSString *> *params = postParam.mDicParams;
    BOOL isAsycn = postParam.mBolAsycn;
    
    if (url) {
        
        NSMutableURLRequest *request = [self fGetURLRequest:postParam];
       
        NSURLSessionTask *cTask = nil;
        dispatch_semaphore_t sem = nil;
        
        if (!isAsycn) {
            
            SDKLog(@"!! < dispatch_semaphore_create > !!")
            sem = dispatch_semaphore_create(0);
        }
        
#if DEBUG
        NSString *keyUUID = [NSUUID UUID].UUIDString;
#endif
        
        SDKLog(@"[%@] <%@> 请求 url:%@  params:%@", request.HTTPMethod, keyUUID, url, params)
        cTask = [self.mSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            SDKLog(@"[%@] <%@> 收到数据 %@ string = %@"
                   , request.HTTPMethod
                   , keyUUID
                   , @(data.length)
                   , [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding])
            
            if (block) {
                
                block(data, response, error);
            }
            
            if (!isAsycn) {
                
                SDKLog(@"!! < dispatch_semaphore_signal > !!")
                dispatch_semaphore_signal(sem);
            }
        }];
        
        if (cTask) {
            
            SDKLog(@"开启任务[%@]", @(cTask.taskIdentifier));
            [cTask resume];
            
            if (!isAsycn) {
                
                SDKLog(@"!! < dispatch_semaphore_wait > !!")
                dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
            }
        }
        else {
            
            SDKAssert
            if (block) {
                
                block(nil, nil, CLOErrorMake(@"CLOCommon", -404, @"参数错误"));
            }
        }
        
        cTask = nil;
        request = nil;
    }
    else {
        
        if (block) {
            
            block(nil, nil, CLOErrorMake(@"CLOCommon", -404, @"参数错误"));
        }
        SDKAssertionLog(NO, @"URL 为空");
    }
}

#pragma mark - 获取Requset
- (NSMutableURLRequest *)fGetURLRequest:(CLONetworkingObject *)postParam
{
    NSMutableURLRequest *request = nil;
    NSURL *url = postParam.mUrlPath;
    
    switch (postParam.mEumContentType) {
        case eCLONetworkingContentType_Text:
        {
            NSString *strBody = [self fGotParamsStringByDictionary:postParam.mDicParams];
            NSString *strNUrl = [[NSString alloc] initWithFormat:@"%@?%@", url.absoluteString, strBody];
            NSURL *nUrl = [NSURL URLWithString:strNUrl];
            request = [[NSMutableURLRequest alloc] initWithURL:nUrl];
            request.HTTPBody = [strBody dataUsingEncoding:NSUTF8StringEncoding];
            [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
            
        }break;
        case eCLONetworkingContentType_Json:
        {
            request = [[NSMutableURLRequest alloc] initWithURL:url];
            request.HTTPBody = [NSJSONSerialization JSONDataWithDictionary:postParam.mDicParams];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }break;
            
        default:
            SDKAssert;
            return nil;
    }
    // 如果有header 添加
    NSDictionary *headers = postParam.mDicHeaders;
    if (request && headers)
    {
        for (int ir = 0; ir < headers.allKeys.count; ir ++) {
            
            NSString *iKey = headers.allKeys[ir];
            NSString *iValue = headers[iKey];
            [request setValue:iValue forHTTPHeaderField:iKey];
        }
    }
    
    request.HTTPMethod = postParam.mEumHttpMethod == eCLONetworkingMethod_GET ? @"GET" : @"POST";
    request.timeoutInterval = postParam.mFltTimeoutInterval;
    return request;
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    [self vGotRequestByTask:downloadTask withLocation:location withError:nil];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    CLONetworkingRequest *keyObj = nil;
    NSString *key = [[NSString alloc] initWithFormat:@"%@", @(downloadTask.taskIdentifier)];
    if (key) {
        
        @synchronized (self.mDicKeyObj) {
            
            keyObj = self.mDicKeyObj[key];
        }
    }
    SDKAssertElseLog(@"");
    
    if (keyObj) {
        
        SDKLog(@"[%@] <%@> 进度报告：数据 URL = %@ ； %@/%@"
               , downloadTask.currentRequest.HTTPMethod
#ifdef DEBUG
               , keyObj.mDebug_UUID
#else
               , @"(release null)"
#endif
               , keyObj.mObjParam.mUrlPath
               , @(totalBytesWritten)
               , @(totalBytesExpectedToWrite));
        
        if (keyObj.mBlock_Progress) {
            
            keyObj.mBlock_Progress(totalBytesWritten, totalBytesExpectedToWrite);
        }
    }
    else {
        
#ifdef DEBUG
        if (totalBytesWritten != totalBytesExpectedToWrite) {
            
            SDKAssertionLog(NO, @"出现问题了");
        }
        else {
            
            SDKLog(@"可能已经完成了，调用了完成回调，删除了对应key，所以这里找不到");
        }
#endif
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    [self vGotRequestByTask:task withLocation:nil withError:error];
}

@end
