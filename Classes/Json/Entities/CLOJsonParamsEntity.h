//
//  CLOJsonParamsEntity.h
//  CLOCommon
//
//  Created by Cc on 15/12/28.
//  Copyright © 2015年 PinguoSDK. All rights reserved.
//

#import "CLOEntity.h"


    @class CLOJsonParamsStretagyEntity;


#define CLOParamStretagy(key,paramKey,classT,stre) \
    key : [[CLOJsonParamsStretagyEntity alloc] initWithKey:key  \
                                              withParamKey:paramKey \
                                                 withClass:classT \
                                              withStretagy:stre]

typedef NS_ENUM(NSUInteger, eCLOParamsStretagy) {

    eCLOParamsStretagyNullable = 0,
    eCLOParamsStretagyNonull,
};

@interface CLOJsonParamsEntity : CLOEntity

- (NSDictionary<NSString *, NSString *> *)pGotParams;

    /**
     * 返回一个规则 如果想上传参数必须这种格式 mParam_xxx 属性必须在字典中定义清楚
     *
     *  return @{
            CLOParamStretagy(@"mParam_Platform", @"platform", [NSNumber class], eCLOParamsStretagyNonull)
        }
     */
    + (NSDictionary<NSString *, CLOJsonParamsStretagyEntity *> *)sGotParamsStrategy;

    /**
     *  验证参数合法性，如果返回NO表示验证失败，- pGotParams 方法返回nil
     */
    + (BOOL)sCheckParams;

@end

@interface CLOJsonParamsStretagyEntity : CLOEntity

    @property (nonatomic,strong) NSString *mStrKey;
    @property (nonatomic,strong) NSString *mStrParamKey;
    @property (nonatomic,assign) eCLOParamsStretagy mEumStretagy;
    @property (nonatomic,strong) Class mClsType;

- (instancetype)initWithKey:(NSString *)key
               withParamKey:(NSString *)paramKey
                  withClass:(Class)classT
               withStretagy:(eCLOParamsStretagy)stretagy;

@end
