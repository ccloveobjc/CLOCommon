//
//  NSJSONSerialization+CLOCommonJson.m
//  CLOCommon
//
//  Created by Cc on 2019/7/25.
//

#import "NSJSONSerialization+CLOCommonJson.h"
#import <CLOCommon/CLOCommonCore.h>

@implementation NSJSONSerialization (CLOCommonJson)

+ (NSDictionary *)JSONObjectWithContentsOfURL:(NSURL *)url
{
    if ([url isKindOfClass:[NSURL class]]) {
        
        NSData *jsonData = [[NSData alloc] initWithContentsOfURL:url];
        if ([jsonData isKindOfClass:[NSData class]]) {
            
            return [self JSONObjectWithData:jsonData];
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

+ (NSDictionary *)JSONObjectWithJsonContentsOfFile:(NSString *)filePath
{
    if ([filePath isKindOfClass:[NSString class]]) {
        
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];
        if ([jsonData isKindOfClass:[NSData class]]) {
            
            return [self JSONObjectWithData:jsonData];
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

+ (NSDictionary *)JSONObjectWithData:(NSData *)data
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

+ (NSData *)JSONDataWithDictionary:(NSDictionary *)json
{
    return [self JSONDataWithDictionary:json withOption:NSJSONWritingPrettyPrinted];
}

+ (NSData *)JSONDataWithDictionary:(NSDictionary *)json withOption:(NSJSONWritingOptions)op
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


+ (NSDictionary *)JSONObjectWithJsonString:(NSString *)jsonString
{
    if ([jsonString isKindOfClass:[NSString class]]) {
        
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        if ([jsonData isKindOfClass:[NSData class]]) {
            
            return [self JSONObjectWithData:jsonData];
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

+ (NSArray *)JSONObjectWithArrayData:(NSData *)data
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

+ (NSString *)JSONStringWithDictionary:(NSDictionary *)json
{
    NSData *dataJson = [self JSONDataWithDictionary:json];
    if (dataJson) {
    
        NSString *aString = [[NSString alloc] initWithData:dataJson encoding:NSUTF8StringEncoding];
        return aString;
    }
    else {
        
        SDKErrorLog(@"json != Json");
    }
    return nil;
}
@end
