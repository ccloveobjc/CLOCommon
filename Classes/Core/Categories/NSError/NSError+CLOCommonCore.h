//
//  NSError+CLOCommonCore.h
//  CLOCommon
//
//  Created by Cc on 2019/7/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 @param domain  string      如：@"appDemain"
 @param code    int         如：403
 @param msg     string      如：@"错误信息"
 */
#define CLOErrorMake(domain, code, msg) [NSError CLOGotError:domain withCode:code withDescription:msg]

@interface NSError (CLOCommonCore)

+ (NSDictionary *)CLOGotUserInfoWithDescription:(NSObject *)desc;

+ (NSError *)CLOGotError:(NSString *)domain withCode:(NSInteger)code withDescription:(NSString *)desc;

@end

NS_ASSUME_NONNULL_END
