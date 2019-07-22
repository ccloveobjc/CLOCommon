//
//  pg_sdk_common_json_entity.h
//  pg_sdk_common
//
//  Created by Cc on 15/12/15.
//  Copyright © 2015年 PinguoSDK. All rights reserved.
//

#import "pg_sdk_common_entity.h"


    @class pg_sdk_common_json_stretagy_entity;


typedef NS_ENUM(NSUInteger, ePg_sdk_common_json_stretagy) {
    
    ePg_sdk_common_json_stretagy_nullable = 0,
    ePg_sdk_common_json_stretagy_nonull,
};


#define pg_common_json_stretagy(subkey,classT,stre,jsonClassT) \
                                    subkey : [[pg_sdk_common_json_stretagy_entity alloc] initWithSubkey:subkey  \
                                                                                                                                     withClass:classT \
                                                                                                                                withStretagy:stre \
                                                                                                                              withJsonClass:jsonClassT]


@interface pg_sdk_common_json_entity : pg_sdk_common_entity


// ======================  通过 json 转成 Entity ======================
//                                                                                                                                                =
    /*
     * 是否解析成功
     *  必须要readonly   不能自行构造entity， 需要构造也必须走解析流程，需要传入NSDictionary 来解析
     */
    @property (nonatomic,assign,readonly) BOOL mBolAnalyzeSuccessfully;

    /** 原始json数据 */
    @property (nonatomic,strong,readonly) NSDictionary *mDicJson;

    /**
     * 返回一个规则 如果定义了 mJsn_status 属性必须在字典中定义
     *
     *  return @{
     *      pg_common_json_stretagy(@"status", [NSNumber class], ePg_sdk_common_json_stretagy_nonull)
     *      , pg_common_json_stretagy(@"message", [NSString class], ePg_sdk_common_json_stretagy_nonull)
     *  }
     */
    + (NSDictionary *)sGotJsonStrategy;

    /**
     *  解析后check字段，如果返回NO，则 mBolAnalyzeSuccessfully 为NO
     */
    + (BOOL)sCheckJson:(id)selfEty;


- (instancetype)initWithJSON:(NSDictionary *)json NS_DESIGNATED_INITIALIZER;


- (NSDictionary<NSString *, NSString *> *)gotJsnPropertiesNameByClass:(Class)classType;

//                                                                                                                                                =
// ======================  通过 json 转成 Entity ======================



// ======================  通过 Entity 转成 json ======================
//                                                                                                                                                =

/**
 *  获取 json 对应 Entity
 *  ⚠️ 有一倍的性能影响
 */
- (NSDictionary *)c_CDS_gotJson;

+ (NSDictionary<NSString *, pg_sdk_common_json_stretagy_entity *> *)c_CDS_onDB2Json;

//                                                                                                                                                =
// ======================  通过 Entity 转成 json ======================
@end

#define OBJ2JsonStretagy(skey, classT, stre, jsonClassT) \
skey : [[pg_sdk_common_json_stretagy_entity alloc] initWithSubkey:skey withClass:classT withStretagy:stre withJsonClass:jsonClassT]
@interface pg_sdk_common_json_stretagy_entity : pg_sdk_common_entity


    @property (nonatomic,strong) NSString *mStrKey;
    @property (nonatomic,assign) ePg_sdk_common_json_stretagy mEumStretagy;
    @property (nonatomic,strong) Class mClassType;
    @property (nonatomic,strong) Class mJsonClassType;


- (instancetype)initWithSubkey:(NSString *)skey
                     withClass:(Class)classT
                  withStretagy:(ePg_sdk_common_json_stretagy)stre
                 withJsonClass:(Class)jsonClassT;

@end
