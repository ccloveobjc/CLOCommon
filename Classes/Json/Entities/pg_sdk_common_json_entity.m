//
//  pg_sdk_common_json_entity.m
//  pg_sdk_common
//
//  Created by Cc on 15/12/15.
//  Copyright © 2015年 PinguoSDK. All rights reserved.
//

#import "pg_sdk_common_json_entity.h"
#import <objc/runtime.h>
#import "CLOLogHelper.h"
#import "NSDictionary+pg_common_unitils.h"
#import "NSObject+pg_common_class.h"

#define SelfClass pg_sdk_common_json_entity

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
@interface pg_sdk_common_json_entity()

    @property (nonatomic,strong) NSDictionary *mDicJson;

@end
@implementation pg_sdk_common_json_entity

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
                
                pg_sdk_common_json_stretagy_entity *dicStreValue = [dicStre c_common_gotValueForKey:webKey withClass:[pg_sdk_common_json_stretagy_entity class]];
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

- (BOOL)anlz:(pg_sdk_common_json_stretagy_entity *)dicStre withValue:(id)value
{
    if (dicStre) {
        
        NSString *key = dicStre.mStrKey;
        Class cls = dicStre.mClassType;
        if (cls) {
            
            if ([cls isSubclassOfClass:[NSString class]]
                || [cls isSubclassOfClass:[NSNumber class]]
                || [cls isSubclassOfClass:[NSDictionary class]]
                || [cls isSubclassOfClass:[NSArray class]]) {
                
                if (value) {
                    
                    if ([[value class] isSubclassOfClass:dicStre.mJsonClassType]) {
                        
                        switch (dicStre.mEumStretagy) {
                            case ePg_sdk_common_json_stretagy_nonull:
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
                            case ePg_sdk_common_json_stretagy_nullable:
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
                    
                    if (dicStre.mEumStretagy == ePg_sdk_common_json_stretagy_nullable) {
                        
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
                            
                            pg_sdk_common_json_entity *vv = [[cls alloc] initWithJSON:value];
                            if (vv) {
                                
                                [self setValue:vv forKey:key];
                                if (!vv.mBolAnalyzeSuccessfully) {
                                    
                                    return NO;
                                }
                            }
                            else {
                                
                                SelfAssert(@"pg_sdk_common_json_entity alloc 为 nil");
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
                                    
                                    pg_sdk_common_json_entity *vv = [[cls alloc] initWithJSON:dic];
                                    if (vv) {
                                        
                                        [arrT addObject:vv];
                                        if (!vv.mBolAnalyzeSuccessfully) {
                                            
                                            return NO;
                                        }
                                    }
                                    else {
                                        
                                        SelfAssert(@"pg_sdk_common_json_entity alloc 为 nil");
                                        return NO;
                                    }
                                }
                                else {
                                    
                                    SelfAssert(@"不是一个Dictionary 错误类型");
                                    return NO;
                                }
                            }
                            if (arrT.count > 0) {
                                
                                [self setValue:arrT forKey:key];
                            }
                        }
                        else {
                            
                            SelfAssert(@"mJsonClassType 类型不匹配");
                            return NO;
                        }
                    }
                    else {
                        
                        if (dicStre.mEumStretagy == ePg_sdk_common_json_stretagy_nullable) {
                            
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
                
                pg_sdk_common_json_stretagy_entity *dicStreValue = [dicStre c_common_gotValueForKey:webKey withClass:[pg_sdk_common_json_stretagy_entity class]];
                if (dicStreValue) {
                    
                    id value = [self cv_ssss:dicStreValue];
                    if (value) {
                        
                        [mutableDic setValue:value forKey:webKey];
                    }
                    else {
                        
                        if (dicStreValue.mEumStretagy == ePg_sdk_common_json_stretagy_nullable) {
                            
                            continue;
                        }
                        else {
                        
                            SelfAssert(@"没有值", sKey);
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


- (id)cv_ssss:(pg_sdk_common_json_stretagy_entity *)stre
{
    if ([self c_common_propertyForKey:stre.mStrKey]) {
    
        id value = [self valueForKey:stre.mStrKey];
        if (value) {
            
            if ([stre.mJsonClassType isSubclassOfClass:[NSString class]] || [stre.mJsonClassType isSubclassOfClass:[NSNumber class]]) {
                
                if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
                    
                    return value;
                }
                else {
                    
                    SDKAssertionLog(NO, @"类型不对");
                    return nil;
                }
            }
            else if ([stre.mJsonClassType isSubclassOfClass:[pg_sdk_common_json_entity class]]) {
                
                if ([value isKindOfClass:[pg_sdk_common_json_entity class]]) {
                    
                    return [value c_CDS_gotJson];
                }
                else {
                    
                    SDKAssertionLog(NO, @"类型不对");
                    return nil;
                }
            }
            else if ([stre.mJsonClassType isSubclassOfClass:[NSArray class]]) {
                
                if ([value isKindOfClass:[NSArray class]]) {
                    
                    NSMutableArray *mArr = [NSMutableArray array];
                    for (pg_sdk_common_json_entity  *objX in ((NSArray *)value)) {
                        
                        if ([objX isKindOfClass:[pg_sdk_common_json_entity class]]) {
                            
                            [mArr addObject:[objX c_CDS_gotJson]];
                        }
                        else if([objX isKindOfClass:[NSNumber class]] || [objX isKindOfClass:[NSString class]]) {
                            
                            [mArr addObject:objX];
                        }
                        else {
                            
                            SDKAssertionLog(NO, @"类型不对");
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
//    NSMutableDictionary *dicJson = [NSMutableDictionary dictionary];
//    NSDictionary *dicStre = [[self class] c_CDS_onDB2Json];
//    for (pg_sdk_common_json_stretagy_entity *stre in dicStre.allValues) {
//        
//        if ([stre.mJsonClassType isSubclassOfClass:[NSString class]]
//            || [stre.mJsonClassType isSubclassOfClass:[NSNumber class]]) {
//            
//            if ([self c_common_propertyForKey:stre.mStrKey]) {
//                
//                [dicJson setValue:[self valueForKey:stre.mStrKey] forKey:[stre.mStrKey c_common_removeOccurrencesOfString:@"mJsn_"]];
//            }
//            else {
//                
//                SDKAssert
//            }
//        }
//        else if ([stre.mJsonClassType isSubclassOfClass:[NSArray class]]) {
//            
//            if ([self c_common_propertyForKey:stre.mStrKey]) {
//                
//                NSArray *sArr = [[self valueForKey:stre.mStrKey] c_common_convertToClass:[NSArray class]];
//                if (sArr) {
//                    
//                    NSMutableArray *arrJson = [NSMutableArray array];
//                    for (pg_sdk_common_json_entity *objEty in sArr) {
//                        
//                        NSDictionary *dicBase = [objEty cv_CDS_gotJsonDic];
//                        if (dicBase) {
//                            
//                            [arrJson addObject:dicBase];
//                        }
//                        else {
//                            
//                            SDKAssert
//                        }
//                    };
//                    if (arrJson.count > 0) {
//                        
//                        [dicJson setValue:arrJson forKey:stre.mStrKey];
//                    }
//                }
//                
////                NSSet *setArr = [[self valueForKey:stre.mStrKey] c_common_convertToClass:[NSSet class]];
////                if (setArr) {
////                    
////                    NSMutableArray *arrJson = [NSMutableArray array];
////                    
////                    NSArray *arrT = [setArr c_common_sortCommonDescriptorWithKey:@"dlb_createTime" ascending:YES];
////                    
////                    for (NSManagedObject *oBase in arrT) {
////                        
////                        NSDictionary *dicBase = [oBase cv_CDS_gotJsonDic];
////                        if (dicBase) {
////                            
////                            [arrJson addObject:dicBase];
////                        }
////                        else {
////                            
////                            SDKAssert
////                        }
////                    }
////                    if (arrJson.count > 0) {
////                        
////                        [dicJson setValue:arrJson forKey:stre.mStrJsonKey];
////                    }
////                }
//            }
//            else {
//                
//                SDKAssert
//            }
//        }
//        else if ([stre.mJsonClassType isSubclassOfClass:[NSDictionary class]]) {
//            
//            if ([self c_common_propertyForKey:stre.mStrKey]) {
//                
////                id valueOri = [self valueForKey:stre.mStrKey];
////                if ([valueOri isKindOfClass:[NSManagedObject class]]) {
////                
////                    NSManagedObject *oBase = [valueOri c_common_convertToClass:[NSManagedObject class]];
////                    NSDictionary *dicBase = [oBase cv_CDS_gotJsonDic];
////                    if (dicBase) {
////                        
////                        [dicJson setValue:dicBase forKey:stre.mStrJsonKey];
////                    }
////                    else {
////                        
////                        SDKAssert
////                    }
////                }
////                else if ([valueOri isKindOfClass:[NSData class]]) {
////                    
////                    id vData = [NSMutableData c_common_unarchiver:valueOri];
////                    if ([vData isKindOfClass:stre.mClsJsonType]) {
////                        
////                        [dicJson setValue:vData forKey:stre.mStrJsonKey];
////                    }
////                    else {
////                        
////                        SDKAssert
////                    }
////                }
////                else {
////                    
////                    //可能为nil
////                }
//            }
//            else {
//                
//                SDKAssert
//            }
//        }
//        else {
//            
//            SDKAssert
//        }
//    }
//    
//    return dicJson;
}

+ (NSDictionary<NSString *,pg_sdk_common_json_stretagy_entity *> *)c_CDS_onDB2Json
{
    SDKAssertionLog(NO, @"子类实现");
    return nil;
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

@implementation pg_sdk_common_json_stretagy_entity

- (instancetype)initWithSubkey:(NSString *)skey withClass:(Class)classT withStretagy:(ePg_sdk_common_json_stretagy)stre withJsonClass:(Class)jsonClassT
{
    SDKAssertionLog(skey, @"");
    self = [super init];
    if (self) {
        
        _mStrKey = [NSString stringWithFormat:@"mJsn_%@", skey];
        _mClassType = classT;
        _mEumStretagy = stre;
        _mJsonClassType = jsonClassT;
    }
    
    return self;
}

@end