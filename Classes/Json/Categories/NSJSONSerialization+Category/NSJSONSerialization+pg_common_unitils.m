//
//  NSJSONSerialization+PGUnitils.m
//  MIX_SDKDEMO
//
//  Created by Cc on 14-6-2.
//  Copyright (c) 2014年 权欣权忆. All rights reserved.
//

#import "NSJSONSerialization+pg_common_unitils.h"

//#import "NSData+pg_common_hex.h"
//#import "NSData+pg_common_aes_crypt.h"
//#import "NSData+pg_common_3des_crypt.h"
//#import "pg_sdk_common_gtm_base64.h"
#import "CLOLogHelper.h"

@implementation NSJSONSerialization (pg_common_unitils)

+ (NSDictionary *)c_common_JSONObjectWithContentsOfURL:(NSURL *)url
{
    if ([url isKindOfClass:[NSURL class]]) {
        
        NSData *jsonData = [[NSData alloc] initWithContentsOfURL:url];
        if ([jsonData isKindOfClass:[NSData class]]) {
            
            return [self c_common_JSONObjectWithData:jsonData];
        }
        else {
            
            SDKErrorLog(@"jsonData != NSData 1");
        }
    }
    else {
        
        SDKErrorLog(@"filePath != NSURL");
    }
    
    return nil;
}

+ (NSDictionary *)c_common_JSONObjectWithJsonContentsOfFile:(NSString *)filePath
{
    if ([filePath isKindOfClass:[NSString class]]) {
        
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
        if ([jsonData isKindOfClass:[NSData class]]) {
            
            return [self c_common_JSONObjectWithData:jsonData];
        }
        else {
            
            SDKErrorLog(@"jsonData != NSData 2");
        }
    }
    else {
        
        SDKErrorLog(@"filePath != NSString");
    }
    
    return nil;
}

+ (id)vc_common_JSONObjectWithData:(NSData *)data
{
    if ([data isKindOfClass:[NSData class]]) {
        
        NSError *error = nil;
        id product = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingAllowFragments
                                                       error:&error];
        if (error == nil) {
            
            if ([product isKindOfClass:[NSDictionary class]] || [product isKindOfClass:[NSArray class]]) {
                
                return product;
            }
            else {
                
                SDKErrorLog(@"product != NSDictionary || product != NSArray");
            }
        }
        else {
            
            SDKErrorLog(@"JSONObjectWithData return NO : %@",error);
        }
    }
    else {
        
        SDKErrorLog(@"data != NSData");
    }
    
    return nil;
}

+ (NSDictionary *)c_common_JSONObjectWithData:(NSData *)data
{
    NSDictionary *product = [self vc_common_JSONObjectWithData:data];
    if ([product isKindOfClass:[NSDictionary class]]) {
        
        return product;
    }
    else {
        
        SDKErrorLog(@"product != NSDictionary");
    }
    
    return nil;
}

+ (NSData *)c_common_JSONDataWithDictionary:(NSDictionary *)json
{
    return [self c_common_JSONDataWithDictionary:json withOption:NSJSONWritingPrettyPrinted];
}

+ (NSData *)c_common_JSONDataWithDictionary:(NSDictionary *)json withOption:(NSJSONWritingOptions)op
{
    NSDictionary *jsonDictionary = json;
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:op
                                                         error:&parseError];
    if (parseError) {
        
        SDKErrorLog(@"%@",parseError);
        return nil;
    }
    
    return jsonData;
}


+ (NSDictionary *)c_common_JSONObjectWithJsonString:(NSString *)jsonString
{
    if ([jsonString isKindOfClass:[NSString class]]) {
     
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        if ([jsonData isKindOfClass:[NSData class]]) {
            
            return [self c_common_JSONObjectWithData:jsonData];
        }
        else {
            
            SDKErrorLog(@"jsonData != NSData 3");
        }
    }
    else {
        
        SDKErrorLog(@"jsonString != NSString");
    }
    
    return nil;
}

+ (NSArray *)c_common_JSONObjectWithArrayData:(NSData *)data
{
    NSArray *product = [self vc_common_JSONObjectWithData:data];
    if ([product isKindOfClass:[NSArray class]]) {
        
        return product;
    }
    else {
        
        SDKErrorLog(@"product != NSArray");
    }
    
    return nil;
}

@end
