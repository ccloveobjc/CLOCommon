//
//  CLOJsonEntity.m
//  CLOCOmmon
//
//  Created by Cc on 15/12/15.
//  Copyright © 2015年 PinguoSDK. All rights reserved.
//

#import "CLOJsonEntity.h"
#import <objc/runtime.h>
#import <CLOCommon/CLOCommonCore.h>

#define SelfClass CLOJsonEntity

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
@interface CLOJsonEntity()

    @property (nonatomic,strong) NSDictionary *mDicJson;

@end
@implementation CLOJsonEntity

- (instancetype)init
{
    return [self initWithJSON:nil];
}

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        
        _mDicJson = json;
        _mBolAnalyzeSuccessfully = [self loadJSON:json];
    }
    return self;
}

- (BOOL)loadJSON:(NSDictionary *)json
{
    if (json) {
        
        return [self loadJSONByClass:[self class] withDic:json];
    }
    else {
        
        return NO;
    }
}

- (BOOL)loadJSONByClass:(Class)classType withDic:(NSDictionary *)dic
{
    Class superClass = class_getSuperclass(classType);
    if (![superClass isEqual:[NSObject class]]) {
        
        if (superClass != nil && ![superClass isEqual:[SelfClass class]])
        {
            if (![self loadJSONByClass:superClass withDic:dic]) {
                
                return NO;
            }
        }
        
        NSDictionary *dicPros = [self gotJsnPropertiesNameByClass:classType];
        NSDictionary *dicStre = [classType sGotJsonStrategy];
        for (NSString *sKey in dicPros.allKeys) {
            
            NSString *webKey = dicPros[sKey];
            if ([webKey isKindOfClass:[NSString class]] && [sKey isKindOfClass:[NSString class]]) {
                
                CLOJsonStretagyEntity *dicStreValue = [dicStre CLOGotValueForKey:webKey withClass:[CLOJsonStretagyEntity class]];
                if (dicStreValue) {
                    
                    if (![self anlz:dicStreValue withValue:dic[webKey]]) {
                        
                        return NO;
                    }
                }
                else {
                    
                    SelfAssert(@"头文件定义了 %@ sGotStrategy 中也必须定义", sKey);
                    return NO;
                }
            }
            else {
                
                SelfAssert(@"没有找到webKey");
                return NO;
            }
        }
        //check
        if (![classType sCheckJson:self]) {
            
            SelfAssert(@"CheckJson 失败");
            return NO;
        }
    }
    else {
        
        SelfAssert(@"大异常");
        return NO;
    }
    
    return YES;
}

+ (NSDictionary *)sGotJsonStrategy
{
    return nil;
}
+ (BOOL)sCheckJson:(id)selfEty
{
    return YES;
}

- (BOOL)anlz:(CLOJsonStretagyEntity *)dicStre withValue:(id)value
{
    if (dicStre) {
        
        NSString *key = dicStre.mStrKey;
        Class cls = dicStre.mClassType;
        if (cls) {
            
            if ([cls isSubclassOfClass:[NSString class]]
                || [cls isSubclassOfClass:[NSNumber class]]
                || [cls isSubclassOfClass:[NSDictionary class]]
                || [cls isSubclassOfClass:[NSArray class]]) {
                
                if (value && value != [NSNull null]) {
                    
                    if ([[value class] isSubclassOfClass:dicStre.mJsonClassType]) {
                        
                        switch (dicStre.mEumStretagy) {
                            case eCLOJsonStretagyNonull:
                            {
                                if (value) {
                                    
                                    [self setValue:value forKey:key];
                                }
                                else {
                                    
                                    SelfAssert(@"必须要有值 key = %@", key);
                                    return NO;
                                }
                            }
                                break;
                            case eCLOJsonStretagyNullable:
                            {
                                if (value) {
                                    
                                    [self setValue:value forKey:key];
                                }
                            }
                                break;
                                
                            default:
                                SDKAssert;
                                break;
                        }
                    }
                    else {
                        
                        SelfAssert(@"定义和目标类型不匹配 定义：%@", dicStre.mClassType);
                        return NO;
                    }
                }
                else {
                    
                    if (dicStre.mEumStretagy == eCLOJsonStretagyNullable) {
                        
                    }
                    else {
                        
                        SelfAssert(@"key : %@ 这个值必须要有！", dicStre.mStrKey);
                        return NO;
                    }
                }
            }
            else {
                
                if ([cls isSubclassOfClass:[SelfClass class]]) {
                    
                    if ([value isKindOfClass:[NSDictionary class]]) {
                        
                        if ([value isKindOfClass:dicStre.mJsonClassType]) {
                            
                            CLOJsonEntity *vv = [[cls alloc] initWithJSON:value];
                            if (vv) {
                                
                                [self setValue:vv forKey:key];
                                if (!vv.mBolAnalyzeSuccessfully) {
                                    
                                    return NO;
                                }
                            }
                            else {
                                
                                SelfAssert(@"CLOJsonEntity alloc 为 nil");
                                return NO;
                            }
                        }
                        else {
                            
                            SelfAssert(@"mJsonClassType 类型不匹配");
                            return NO;
                        }
                    }
                    else if ([value isKindOfClass:[NSArray class]]) {
                        
                        if ([value isKindOfClass:dicStre.mJsonClassType]) {
                            
                            NSMutableArray *arrT = [NSMutableArray array];
                            for (NSDictionary *dic in value) {
                                
                                if ([dic isKindOfClass:[NSDictionary class]]) {
                                    
                                    CLOJsonEntity *vv = [[cls alloc] initWithJSON:dic];
                                    if (vv) {
                                        
                                        [arrT addObject:vv];
                                        if (!vv.mBolAnalyzeSuccessfully) {
                                            
                                            return NO;
                                        }
                                    }
                                    else {
                                        
                                        SelfAssert(@"CLOJsonEntity alloc 为 nil");
                                        return NO;
                                    }
                                }
                                else {
                                    
                                    SelfAssert(@"不是一个Dictionary 错误类型");
                                    return NO;
                                }
                            }
                            if (arrT != nil) {
                                
                                [self setValue:arrT forKey:key];
                            }
                        }
                        else {
                            
                            SelfAssert(@"mJsonClassType 类型不匹配");
                            return NO;
                        }
                    }
                    else {
                        
                        if (dicStre.mEumStretagy == eCLOJsonStretagyNullable) {
                            
                        }
                        else {
                            
                            SelfAssert(@"key : %@ 这个值必须要有", dicStre.mStrKey);
                            return NO;
                        }
                    }
                }
                else {
                    
                    SelfAssert(@"基类类型错误");
                    return NO;
                }
            }
        }
        else {
            
            SelfAssert(@"Class 不能为 nil");
            return NO;
        }
    }
    else {
        
        SelfAssert(@"待反射value 为 nil");
        return NO;
    }
    
    return YES;
}

#pragma mark - Ety 2 Json

- (NSDictionary *)c_CDS_gotJson
{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    if ([self cv_CDS_gotJsonDic:mutDic WithClass:[self class]]) {
    
        return mutDic;
    }
    
    return nil;
}

- (BOOL)cv_CDS_gotJsonDic:(NSMutableDictionary *)mutableDic WithClass:(Class)classType
{
    Class superClass = class_getSuperclass(classType);
    if (![superClass isEqual:[NSObject class]]) {
        
        if (superClass != nil && ![superClass isEqual:[SelfClass class]])
        {
            if (![self cv_CDS_gotJsonDic:mutableDic WithClass:superClass]) {
                
                return NO;
            }
        }
        
        NSDictionary *dicPros = [self gotJsnPropertiesNameByClass:classType];
        NSDictionary *dicStre = [classType c_CDS_onDB2Json];
        for (NSString *sKey in dicPros.allKeys) {
            
            NSString *webKey = dicPros[sKey];
            if ([webKey isKindOfClass:[NSString class]] && [sKey isKindOfClass:[NSString class]]) {
                
                CLOJsonStretagyEntity *dicStreValue = [dicStre CLOGotValueForKey:webKey withClass:[CLOJsonStretagyEntity class]];
                if (dicStreValue) {
                    
                    id value = [self cv_ssss:dicStreValue];
                    if (value) {
                        
                        [mutableDic setValue:value forKey:webKey];
                    }
                    else {
                        
                        if (dicStreValue.mEumStretagy == eCLOJsonStretagyNullable) {
                            
                            [mutableDic setValue:[NSNull null] forKey:webKey];
                            continue;
                        }
                        else {
                        
                            SelfAssert(@"没有值 %@", sKey);
                            return NO;
                        }
                    }
                }
                else {
                    continue;
                    SelfAssert(@"头文件定义了 %@ sGotStrategy 中也必须定义", sKey);
                    return NO;
                }
            }
            else {
                
                SelfAssert(@"没有找到webKey");
                return NO;
            }
        }
        //check
        if (![classType sCheckJson:self]) {
            
            SelfAssert(@"CheckJson 失败");
            return NO;
        }
    }
    else {
        
        SelfAssert(@"大异常");
        return NO;
    }
    
    return YES;
}


- (id)cv_ssss:(CLOJsonStretagyEntity *)stre
{
    if ([self CLOPropertyForKey:stre.mStrKey]) {
    
        id value = [self valueForKey:stre.mStrKey];
        if (value) {
            
            if ([stre.mJsonClassType isSubclassOfClass:[NSString class]]) {
                
                if ([value isKindOfClass:[NSString class]]) {
                    
                    return value;
                }
                else {
                    
                    SDKAssertionLog(NO, @"类型不对 strKey = %@, mJsonClassType = %@", stre.mStrKey, stre.mJsonClassType);
                    return nil;
                }
            }
            else if ([stre.mJsonClassType isSubclassOfClass:[NSNumber class]]) {
                
                if ([value isKindOfClass:[NSNumber class]]) {
                    
                    double tmp = [(NSNumber *)value doubleValue];
                    return (isnan(tmp) || isinf(tmp)) ? @(0) : value;
                }
                else {
                    
                    SDKAssertionLog(NO, @"类型不对 strKey = %@, mJsonClassType = %@", stre.mStrKey, stre.mJsonClassType);
                    return nil;
                }
            }
            else if ([stre.mJsonClassType isSubclassOfClass:[NSDictionary class]]) {
                
                if ([value isKindOfClass:[CLOJsonEntity class]]) {
                    
                    return [value c_CDS_gotJson];
                }
                else {
                    
                    SDKAssertionLog(NO, @"类型不对 strKey = %@, mJsonClassType = %@", stre.mStrKey, stre.mJsonClassType);
                    return nil;
                }
            }
            else if ([stre.mJsonClassType isSubclassOfClass:[NSArray class]]) {
                
                if ([value isKindOfClass:[NSArray class]]) {
                    
                    NSMutableArray *mArr = [NSMutableArray array];
                    for (CLOJsonEntity  *objX in ((NSArray *)value)) {
                        
                        if ([objX isKindOfClass:[CLOJsonEntity class]]) {
                            
                            [mArr addObject:[objX c_CDS_gotJson]];
                        }
                        else if([objX isKindOfClass:[NSNumber class]] || [objX isKindOfClass:[NSString class]]) {
                            
                            [mArr addObject:objX];
                        }
                        else {
                            
                            SDKAssertionLog(NO, @"类型不对 strKey = %@, mJsonClassType = %@", stre.mStrKey, stre.mJsonClassType);
                            return nil;
                        }
                    };
                    return mArr;
                }
                else {
                    
                    SDKAssertionLog(NO, @"类型不对");
                    return nil;
                }
            }
        }
    }
    else {
        
        SDKAssert;
    }
    
    return nil;
}

+ (NSDictionary<NSString *,CLOJsonStretagyEntity *> *)c_CDS_onDB2Json
{
    return [self.class sGotJsonStrategy];
//    SDKAssertionLog(NO, @"子类实现");
//    return nil;
}


#pragma mark - 公共
- (NSDictionary<NSString *, NSString *> *)gotJsnPropertiesNameByClass:(Class)classType
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([classType class], &outCount);
    for (int i = 0; i < outCount; ++i) {
        
        objc_property_t property = properties[i];
        NSString *strPropertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                             encoding:NSUTF8StringEncoding];
        if ([strPropertyName hasPrefix:@"mJsn_"]) {
            
            NSString *ppp = [strPropertyName stringByReplacingOccurrencesOfString:@"mJsn_" withString:@""];
            [mDic setValue:ppp forKey:strPropertyName];
        }
    }
    free(properties);
    
    return mDic;
}

@end

@implementation CLOJsonStretagyEntity

- (instancetype)initWithSubkey:(NSString *)skey withClass:(Class)classT withStretagy:(eCLOJsonStretagy)stre withJsonClass:(Class)jsonClassT
{
    SDKAssertionLog(skey, @"");
    self = [super init];
    if (self) {
        
        _mStrKey = [[NSString alloc] initWithFormat:@"mJsn_%@", skey];
        _mClassType = classT;
        _mEumStretagy = stre;
        _mJsonClassType = jsonClassT;
    }
    
    return self;
}

@end
