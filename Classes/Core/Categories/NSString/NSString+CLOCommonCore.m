//
//  NSString+CLOCommonCore.m
//  CLOCommon
//
//  Created by Cc on 9/11/14.
//  Copyright (c) 2014 PinguoSDK. All rights reserved.
//

#import "NSString+CLOCommonCore.h"
#import "CLOLogHelper.h"

@implementation NSString (CLOCommonCore)

- (BOOL)CLOIsRangeOfString:(NSString *)str
{
    if ([str isKindOfClass:[NSString class]]) {
        
        NSRange range = [self rangeOfString:str];
        if (range.location == NSNotFound) {
            
            return NO;
        }
        else {
            
            return YES;
        }
    }
    else {
        
        SDKErrorLog(@"[str isKindOfClass:[NSString class]]  return NO");
    }
    
    return NO;
}

- (NSString *)CLORemoveOccurrencesOfString:(NSString *)str
{
    if ([str isKindOfClass:[NSString class]]) {
        
        NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:self];
        [mutableStr replaceOccurrencesOfString:str
                                    withString:@""
                                       options:NSRegularExpressionSearch
                                         range:NSMakeRange(0, mutableStr.length)];
        
        return mutableStr;
    }
    else {
        
        SDKErrorLog(@"[str isKindOfClass:[NSString class]]  return NO");
    }
    
    return str;
}


- (NSMutableArray<NSNumber *> *)CLOGotFloatArray
{
    NSMutableArray<NSNumber *> *arrM = [NSMutableArray array];
    NSArray *arr = [self componentsSeparatedByString:@","];
    for (NSString *strNum in arr) {
        
        [arrM addObject:@([strNum floatValue])];
    }
    
    return arrM;
}

- (NSMutableArray<NSString *> *)CLOGotStringArray
{
    NSMutableArray<NSString *> *arrM = [NSMutableArray array];
    NSArray *arr = [self componentsSeparatedByString:@","];
    for (NSString *str in arr) {
        
        [arrM addObject:str];
    }
    
    return arrM;
}

- (NSUInteger)CLOGotHexValue
{
    unsigned long colorHex = strtoul([self UTF8String],0,16);
    return colorHex;
}

- (instancetype)CLOGotUTF8StringFromFilePath
{
    NSString *path = self;
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    if ([data isKindOfClass:[NSData class]]) {
        
        NSString *utf8String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([utf8String isKindOfClass:[NSString class]]) {
            
            SDKErrorLog(@"[utf8String isKindOfClass:[NSString class]]   return NO");
        }
        
        return utf8String;
    }
    else {
        
        SDKErrorLog(@"[data isKindOfClass:[NSData class]]  return NO");
    }

    return nil;
}

- (instancetype)CLOCheckEffectString
{
    if (![self hasPrefix:@"Effect="] && ![self hasPrefix:@"EffectOpacity"]) {
        
        return [@"Effect=" stringByAppendingString:self];
    }
    
    return self;
}


- (NSString *)CLOEncodeToWebSafeEscapeString
{
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    NSString *oriString = self;
    if ([oriString isKindOfClass:[NSString class]])
    {
        CFStringRef stringRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                        (__bridge CFStringRef)oriString,
                                                                        NULL,
                                                                        (CFStringRef)@"!*'();:@&=+$/?%#[]",
                                                                        kCFStringEncodingUTF8);
        NSString *outputStr = CFBridgingRelease(stringRef);
        
//        NSString *outputStr2 = [oriString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return outputStr;
    }
    
    return oriString;
}

+ (NSString *)CLOGotDateFormat:(NSDate *)pDate
{
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc] init];
    [pFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *pTime = [pFormatter stringFromDate:pDate];
    return pTime;
}
@end
