//
//  NSDictionary+CLOCommonCore.m
//  CLOCommon
//
//  Created by Cc on 2019/7/25.
//

#import "NSDictionary+CLOCommonCore.h"
#import "CLOLogHelper.h"
#import "NSObject+CLOCommonCore.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSDictionary (CLOCommonCore)

- (instancetype)CLOGotValueForKey:(id)key withClass:(Class)cls
{
    if (key && cls) {
        
        return [self[key] CLOConvertToClass:cls];
    }
    else {
        
        SDKErrorLog(@"(key && cls) = false");
        SDKAssert;
    }
    
    return nil;
}
- (NSString *)CLOGotStringForKey:(id)key
{
    return [self CLOGotValueForKey:key withClass:[NSString class]];
}
- (NSArray *)CLOGotArrayForKey:(id)key
{
    return [self CLOGotValueForKey:key withClass:[NSArray class]];
}
- (NSNumber *)CLOGotNumberForKey:(id)key
{
    return [self CLOGotValueForKey:key withClass:[NSNumber class]];
}
- (NSDictionary *)CLOGotDictionaryForKey:(id)key
{
    return [self CLOGotValueForKey:key withClass:[NSDictionary class]];
}
- (NSURL *)CLOGotURLForKey:(id)key
{
    return [self CLOGotValueForKey:key withClass:[NSURL class]];
}
- (BOOL)CLOGotBOOLForKey:(id)key
{
    return [[self CLOGotNumberForKey:key] boolValue];
}



- (void)CLOSetupValue:(id)value withKey:(id)key withClass:(Class)cls
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
- (void)CLOSetupString:(NSString *)value withKey:(id)key
{
    [self CLOSetupValue:value withKey:key withClass:[NSString class]];
}
- (void)CLOSetupURL:(NSURL *)value withKey:(id)key
{
    [self CLOSetupValue:value withKey:key withClass:[NSURL class]];
}
- (void)CLOSetupNumber:(NSNumber *)value withKey:(id)key
{
    [self CLOSetupValue:value withKey:key withClass:[NSNumber class]];
}
- (void)CLOSetupBOOL:(BOOL)value withKey:(id)key
{
    [self CLOSetupNumber:@(value) withKey:key];
}


- (NSString *)gotSigByKey:(NSString *)strKey
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
