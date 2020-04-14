//
//  CLOJsonParamsEntity.m
//  CLOCommon
//
//  Created by Cc on 15/12/28.
//  Copyright © 2015年 PinguoSDK. All rights reserved.
//

#import "CLOJsonParamsEntity.h"
#import <objc/runtime.h>
#import <CLOCommon/CLOCommonCore.h>

/* 0＝断言下来， 1＝不断言下来*/
#if DEBUG
    #define SelfAssertStrategy 0
#else
    #define SelfAssertStrategy 1
#endif

#if SelfAssertStrategy == 0
    #define SelfAssert(desc, ...) SDKAssertionLog(NO, desc, ##__VA_ARGS__)
#else
    #define SelfAssert(desc, ...) SDKErrorLog(desc, ##__VA_ARGS__)
#endif

@implementation CLOJsonParamsEntity

+ (NSDictionary<NSString *, CLOJsonParamsStretagyEntity *> *)sGotParamsStrategy
{
    return nil;
}

+ (BOOL)sCheckParams
{
    return YES;
}

- (NSDictionary<NSString *, NSString *> *)pGotParams
{
    NSMutableDictionary<NSString *,NSString *> *dicMParams = [NSMutableDictionary dictionary];
    if (![self pGotParamsByClass:[self class] withMDic:dicMParams]) {
        
        return nil;
    }
    
    return dicMParams;
}

- (NSDictionary<NSString *, NSString *> *)gotPropertiesNameByClass:(Class)classType
{
    NSMutableDictionary<NSString *, NSString *> *mDic = [NSMutableDictionary dictionary];
    
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([classType class], &outCount);
    for (int i = 0; i < outCount; ++i) {
        
        objc_property_t property = properties[i];
        NSString *strPropertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                             encoding:NSUTF8StringEncoding];
        if ([strPropertyName hasPrefix:@"mParam_"]) {
            
            NSString *ppp = [strPropertyName stringByReplacingOccurrencesOfString:@"mParam_" withString:@""];
            [mDic setValue:ppp forKey:strPropertyName];
        }
    }
    free(properties);
    
    return mDic;
}

- (BOOL)pGotParamsByClass:(Class)classType withMDic:(NSMutableDictionary<NSString *, NSString *> *)dicMParams
{
    Class superClass = class_getSuperclass(classType);
    if (![superClass isEqual:[NSObject class]] && dicMParams) {
        
        if (superClass != nil && ![superClass isEqual:[CLOJsonParamsEntity class]])
        {
            if (![self pGotParamsByClass:superClass withMDic:dicMParams]) {
                
                return NO;
            }
        }
        
        NSDictionary<NSString *, NSString *> *dicPros = [self gotPropertiesNameByClass:classType];
        NSDictionary<NSString *, CLOJsonParamsStretagyEntity *> *dicStre = [classType sGotParamsStrategy];
        for (NSString *sKey in dicPros.allKeys) {
            
            if ([sKey isKindOfClass:[NSString class]]) {
                
                CLOJsonParamsStretagyEntity *dicStreValue = [dicStre CLOGotValueForKey:sKey withClass:[CLOJsonParamsStretagyEntity class]];
                if (dicStreValue) {
                    
                    id vValue = [self valueForKey:sKey];
                    if (vValue) {
                        
                        if ([vValue isKindOfClass:dicStreValue.mClsType]) {
                         
                            id ivValue = nil;
                            if ([dicStreValue.mClsType isSubclassOfClass:[NSString class]]) {
                                
                                ivValue = vValue;
                            }
                            else if ([dicStreValue.mClsType isSubclassOfClass:[NSNumber class]]) {
                                
                                ivValue = [[NSString alloc] initWithFormat:@"%@", vValue];
                            }
                            else if ([dicStreValue.mClsType isSubclassOfClass:[NSSet class]]) {
                                
                                NSString *strT = [[vValue allObjects] componentsJoinedByString:@","];
                                ivValue = strT;
                            }
                            else {
                            
                                SDKAssertionLog(NO, @"没有定义这种类型的解析规则");
                                return NO;
                            }
                            
                            [dicMParams setValue:ivValue forKey:dicStreValue.mStrParamKey];
                        }
                        else {
                            
                            SelfAssert(@"类型错误 %@", dicStreValue);
                        }
                    }
                    else {
                        //判定是否可选
                        if (dicStreValue.mEumStretagy == eCLOParamsStretagyNonull) {
                            
                            SelfAssert(@"必须要有值 key = %@", dicStreValue);
                        }
                        else {
                            // 可以没有值
                        }
                    }
                }
                else {
                    
                    SelfAssert(@"头文件定义了 %@ sGotStrategy 中也必须定义", sKey);
                }
            }
            else {
                
                SelfAssert(@"没有找到webKey");
            }
        }
        //结束check
        if (![classType sCheckParams]) {
            
            SelfAssert(@"CheckParams 失败");
            return NO;
        }
    }
    else {
        
        SelfAssert(@"大异常");
    }
    
    return YES;
}

@end

@implementation CLOJsonParamsStretagyEntity

- (instancetype)initWithKey:(NSString *)key
               withParamKey:(NSString *)paramKey
                  withClass:(Class)classT
               withStretagy:(eCLOParamsStretagy)stretagy
{
    self = [super init];
    if (self) {
        
        _mStrKey = key;
        _mStrParamKey = paramKey;
        _mClsType = classT;
        _mEumStretagy = stretagy;
    }
    
    return self;
}

@end
