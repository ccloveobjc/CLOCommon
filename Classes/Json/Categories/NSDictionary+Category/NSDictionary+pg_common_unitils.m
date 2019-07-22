//
//  NSDictionary+PGUnitils.m
//  pg_sdk_common
//
//  Created by Cc on 14-10-11.
//  Copyright (c) 2014年 PinguoSDK. All rights reserved.
//

#import "NSDictionary+pg_common_unitils.h"
#import "CLOLogHelper.h"
#import "NSObject+pg_common_class.h"
#import <CommonCrypto/CommonDigest.h>
//#import "NSString+pg_common_unitils.h"

@implementation NSDictionary (pg_common_unitils)

- (id)c_common_gotValueForKey:(id)key withClass:(Class)cls
{
    if (key && cls) {
        
        return [self[key] c_common_convertToClass:cls];
    }
    else {
        
        SDKErrorLog(@"(key && cls) = false");
        SDKAssert;
    }
    
    return nil;
}
- (NSString *)c_common_gotStringForKey:(id)key
{
    return [self c_common_gotValueForKey:key withClass:[NSString class]];
}
- (NSArray *)c_common_gotArrayForKey:(id)key
{
    return [self c_common_gotValueForKey:key withClass:[NSArray class]];
}
- (NSNumber *)c_common_gotNumberForKey:(id)key
{
    return [self c_common_gotValueForKey:key withClass:[NSNumber class]];
}
- (NSDictionary *)c_common_gotDictionaryForKey:(id)key
{
    return [self c_common_gotValueForKey:key withClass:[NSDictionary class]];
}
- (NSURL *)c_common_gotURLForKey:(id)key
{
    return [self c_common_gotValueForKey:key withClass:[NSURL class]];
}
- (BOOL)c_common_gotBOOLForKey:(id)key
{
    return [[self c_common_gotNumberForKey:key] boolValue];
}


- (void)c_common_setupValue:(id)value withKey:(id)key withClass:(Class)cls
{
    if (key) {
        
        if ([value isKindOfClass:cls]) {
            
            [self setValue:value forKey:key];
        }
        else {
            
            SDKAssertionLog(NO, @"value 类型错误");
        }
    }
    else {
        
        SDKAssertionLog(NO, @"key = nil");
    }
}
- (void)c_common_setupString:(NSString *)value withKey:(id)key
{
    [self c_common_setupValue:value withKey:key withClass:[NSString class]];
}
- (void)c_common_setupURL:(NSURL *)value withKey:(id)key
{
    [self c_common_setupValue:value withKey:key withClass:[NSURL class]];
}
- (void)c_common_setupNumber:(NSNumber *)value withKey:(id)key
{
    [self c_common_setupValue:value withKey:key withClass:[NSNumber class]];
}
- (void)c_common_setupBOOL:(BOOL)value withKey:(id)key
{
    [self c_common_setupNumber:@(value) withKey:key];
}


- (NSString *)c_common_gotSigByKey:(NSString *)strKey
{
    NSString *res = nil;
    NSDictionary *params = self;
    NSString *secret = strKey;
    
    if (secret && params) {
        
        NSMutableString *sigStr = [NSMutableString stringWithString:@""];
        NSArray *arr = [[params allKeys] sortedArrayUsingSelector:@selector(compare:)];
        for (NSString *key in arr) {
            
            NSString *value = params[key];
            if ([value isKindOfClass:[NSString class]]) {
                
                [sigStr appendFormat:@"%@=%@", key, value];
            }
            else if ([value isKindOfClass:[NSNumber class]]) {
                
                [sigStr appendFormat:@"%@=%@", key, value];
            }
        }
        
        if ([sigStr length] > 0) {
            
//            SDKLog(@"sigStr = %@", sigStr);
            res = [self.class sEncript:sigStr key:secret encode:NSUTF8StringEncoding];
        }
    }
    SDKAssertElseLog(@"");
    
    return [res length] > 0 ? res : nil;
}

+ (NSString *)sEncript:(NSString *)orgStr key:(NSString *)key encode:(NSStringEncoding)encode
{
    NSMutableString *outStr = [[NSMutableString alloc] initWithCapacity:10];
    
    const char *keyBytes = NULL;
    NSUInteger len = 0;
    if (key != nil&& [key length] > 0)
    {
        NSData *data = [key dataUsingEncoding:encode];
        len = [data length];
        keyBytes = [key UTF8String];
    }
    unsigned char *md5CStr = [self.class sMd5:orgStr];
    int leno = 16;
    Byte ch, ch1, ch2;
    for (int i = 0; i < leno; i++)
    {
        if (keyBytes != NULL)
        {
            ch1 = md5CStr[i];
            ch2 = keyBytes[i % len];
            ch = (Byte)(ch1 ^ ch2);
        }
        else
        {
            ch = md5CStr[i];
        }
        [outStr appendFormat:@"%02x", ch];
    }
    free(md5CStr);
    return outStr;
}

+ (unsigned char *)sMd5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char *md5 = (unsigned char *)malloc(1024);
    memset(md5, 0, 1024);
    CC_MD5(cStr, (unsigned int)strlen(cStr), md5);
    return md5;
}

@end
