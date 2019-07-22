//
//  pg_sdk_common_params_entity.h
//  pg_sdk_common
//
//  Created by Cc on 15/12/28.
//  Copyright © 2015年 PinguoSDK. All rights reserved.
//

#import "pg_sdk_common_entity.h"


    @class pg_sdk_common_params_stretagy_entity;


#define pg_common_param_stretagy(key,paramKey,classT,stre) \
    key : [[pg_sdk_common_params_stretagy_entity alloc] initWithKey:key  \
                                                                                       withParamKey:paramKey \
                                                                                               withClass:classT \
                                                                                          withStretagy:stre]

typedef NS_ENUM(NSUInteger, ePg_sdk_common_params_stretagy) {

    ePg_sdk_common_params_stretagy_nullable = 0,
    ePg_sdk_common_params_stretagy_nonull,
};

@interface pg_sdk_common_params_entity : pg_sdk_common_entity

- (NSDictionary<NSString *, NSString *> *)pGotParams;

    /**
     * 返回一个规则 如果想上传参数必须这种格式 mParam_xxx 属性必须在字典中定义清楚
     *
     *  return @{
            pg_common_param_stretagy(@"mParam_Platform", @"platform", [NSNumber class], ePg_sdk_common_params_stretagy_nonull)
        }
     */
    + (NSDictionary<NSString *, pg_sdk_common_params_stretagy_entity *> *)sGotParamsStrategy;

    /**
     *  验证参数合法性，如果返回NO表示验证失败，- pGotParams 方法返回nil
     */
    + (BOOL)sCheckParams;

@end

@interface pg_sdk_common_params_stretagy_entity : pg_sdk_common_entity

    @property (nonatomic,strong) NSString *mStrKey;
    @property (nonatomic,strong) NSString *mStrParamKey;
    @property (nonatomic,assign) ePg_sdk_common_params_stretagy mEumStretagy;
    @property (nonatomic,strong) Class mClsType;

- (instancetype)initWithKey:(NSString *)key
               withParamKey:(NSString *)paramKey
                  withClass:(Class)classT
               withStretagy:(ePg_sdk_common_params_stretagy)stretagy;

@end
