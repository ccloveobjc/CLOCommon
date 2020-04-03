//
//  NSError+CLOCommonCore.m
//  CLOCommon
//
//  Created by Cc on 2019/7/25.
//

#import "NSError+CLOCommonCore.h"

@implementation NSError (CLOCommonCore)

+ (NSDictionary *)CLOGotUserInfoWithDescription:(NSObject *)desc
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (desc) {
        
        [userInfo setObject:desc forKey:NSLocalizedDescriptionKey];
    }
    else {
        
        [userInfo setObject:@"Code classtype [CLOCommon]" forKey:NSLocalizedDescriptionKey];
    }
    
    return userInfo;
}

+ (NSError *)CLOGotError:(NSString *)domain withCode:(NSInteger)code withDescription:(NSString *)desc
{
    return [NSError errorWithDomain:domain
                               code:code
                           userInfo:[self CLOGotUserInfoWithDescription:desc]];
}

@end
