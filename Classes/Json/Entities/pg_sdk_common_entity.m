//
//  pg_sdk_common_entity.m
//  pg_sdk_common
//
//  Created by Cc on 14/11/25.
//  Copyright (c) 2014年 PinguoSDK. All rights reserved.
//

#import "pg_sdk_common_entity.h"
#import <objc/runtime.h>
#import "CLOLogHelper.h"

#define SelfClass pg_sdk_common_entity

@implementation pg_sdk_common_entity

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    SelfClass *newEntity = [[[self class] allocWithZone:zone] init];
    [self copyEntity:newEntity inClass:[self class]];
    return newEntity;
}

- (void)copyEntity:(SelfClass*)entity inClass:(Class)classType
{
    Class superClass = class_getSuperclass(classType);
    if (superClass != nil && ![superClass isEqual:[SelfClass class]])
    {
        [self copyEntity:entity inClass:superClass];
    }
    
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([classType class], &outCount);
    for (int i = 0; i < outCount; ++i)
    {
        objc_property_t property = properties[i];
        //obj.json_oid
        NSString *strPropertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                             encoding:NSUTF8StringEncoding];
        if ([self fIsFormatWith_mJson:strPropertyName])
        {
            //obj._json_oid
            NSString *strPropertyPrivateName = [@"_" stringByAppendingString:strPropertyName];
            id selfValue = [self valueForKey:strPropertyName];
            id copyValue = nil;
            if ([selfValue isKindOfClass:[NSArray class]]) {
                // NSArray
                copyValue = [[NSMutableArray alloc] initWithArray:selfValue copyItems:YES];
            }
            else if ([selfValue isKindOfClass:[NSDictionary class]]) {
                // NSDictionary
                copyValue = [[NSMutableDictionary alloc] initWithDictionary:selfValue copyItems:YES];
            }
            else {
                // NSString NSNumber NSObject or nil
                copyValue = [selfValue copy];
            }
            [entity setValue:copyValue forKey:strPropertyPrivateName];
        }
        else if ([self fIsWeakProperty:strPropertyName]) {
            
            id selfValue = [self valueForKey:strPropertyName];
            [entity setValue:selfValue forKey:strPropertyName];
        }
        else {
            
//            SDKLog(@"Error：没有copy 这种属性 = %@",strPropertyName)
        }
    }
    free(properties);
}

- (BOOL)fIsFormatWith_mJson:(NSString *)strPropertyName
{
    return ([strPropertyName hasPrefix:@"mStr"] ||
            [strPropertyName hasPrefix:@"mNmb"] ||
            [strPropertyName hasPrefix:@"mArr"] ||
            [strPropertyName hasPrefix:@"mDic"] ||
            [strPropertyName hasPrefix:@"mEty"] ||
            [strPropertyName hasPrefix:@"mEum"] ||
            [strPropertyName hasPrefix:@"mBol"] ||
            [strPropertyName hasPrefix:@"mPot"] ||
            [strPropertyName hasPrefix:@"mRct"] ||
            [strPropertyName hasPrefix:@"mSiz"] ||
            [strPropertyName hasPrefix:@"mFlt"] ||
            [strPropertyName hasPrefix:@"mTfm"] ||
            [strPropertyName hasPrefix:@"mInt"] ||
            [strPropertyName hasPrefix:@"mDta"] ||
            [strPropertyName hasPrefix:@"mUrl"] ||
            [strPropertyName hasPrefix:@"mImg"] ||
            [strPropertyName hasPrefix:@"mBlk"] ||
            [strPropertyName hasPrefix:@"mJsn"]);
//    return YES;
}

- (BOOL)fIsWeakProperty:(NSString *)strPropertyName
{
    return (
            [strPropertyName hasPrefix:@"mWeak"]
            );
}


#pragma mark - Debug description

#ifdef DEBUG
- (NSString *)description
{
    NSMutableString *mString = [NSMutableString stringWithFormat:@"%@ {\r\r",self.class];
    [self descriptionInClass:[self class] space:1 withMutableString:mString];
    [mString appendString:@"\r}"];
    return mString;
}
- (void)descriptionInClass:(Class)classType space:(NSInteger)index withMutableString:(NSMutableString*)mString
{
    Class superClass = class_getSuperclass(classType);
    if (superClass != nil && ![superClass isEqual:[SelfClass class]]) {
        
        [self descriptionInClass:superClass space:(index + 1) withMutableString:mString];
    }
    
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([classType class], &outCount);
    for (int i = 0; i < outCount; ++i) {
        //空格
        for (int j = 0; j < index; ++j) {
            
            [mString appendString:@"> > "];
        }
        
        objc_property_t property = properties[i];
        //obj.json_oid
        NSString *strPropertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                             encoding:NSUTF8StringEncoding];
        //屏蔽搜到这个属性，会死循环
        if ([strPropertyName isEqualToString:@"description"]
            || [strPropertyName isEqualToString:@"debugDescription"]
            || [strPropertyName isEqualToString:@"pDelegate"]) {
            
            continue;
        }
        
        if ([self fIsFormatWith_mJson:strPropertyName]) {
            
            //obj._json_oid
            id selfValue = [self valueForKey:strPropertyName];
            if ([selfValue isKindOfClass:[NSString class]]) {
                
                [mString appendFormat:@"%@ = \"%@\"\r\r",strPropertyName, selfValue];
            }
            else if ([selfValue isKindOfClass:[NSNumber class]]) {
                
                [mString appendFormat:@"%@ = @(%@)\r\r",strPropertyName, selfValue];
            }
            else if ([selfValue isKindOfClass:[NSData class]]) {
            
                NSData *selfDataValue = selfValue;
                [mString appendFormat:@"%@(length) = @(%@)\r\r",strPropertyName, @(selfDataValue.length)];
            }
            else if ([selfValue isKindOfClass:[NSArray class]]) {
                
                [mString appendFormat:@"%@ [ \r\r", strPropertyName];
                for (id valueT in selfValue) {
                    
                    for (int k = 0; k < index; ++k) {
                        [mString appendString:@"> > "];
                    }
                    [mString appendFormat:@"%@ \r\r", valueT];
                }
                [mString appendFormat:@"]\r\r"];
            }
            else {
                
                [mString appendFormat:@"%@ = %@\r\r",strPropertyName, selfValue];
            }
        }
    }
    free(properties);
}
#endif

- (NSString *)sdp
{
#warning [TODO] sdp 简单 单排 输出
    return @"A1{ B1< C1{} > }";
}

@end
