//
//  CLOJsonEntity.h
//  CLOCommon
//
//  Created by Cc on 15/12/15.
//  Copyright © 2015年 PinguoSDK. All rights reserved.
//

#import "CLOEntity.h"


    @class CLOJsonStretagyEntity;


typedef NS_ENUM(NSUInteger, eCLOJsonStretagy) {
    
    eCLOJsonStretagyNullable = 0,
    eCLOJsonStretagyNonull,
};


#define CLOJsonStretagy(subkey, classT, stre, jsonClassT) subkey : [[CLOJsonStretagyEntity alloc] initWithSubkey:subkey  \
                                                                                                       withClass:classT \
                                                                                                    withStretagy:stre \
                                                                                                   withJsonClass:jsonClassT]


@interface CLOJsonEntity : CLOEntity


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
     *  使用 mJsn_status 来定义
     *  return @{
     *      CLOJsonStretagy(@"status", [NSNumber class], eCLOJsonStretagyNonull,  [NSNumber class])
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

+ (NSDictionary<NSString *, CLOJsonStretagyEntity *> *)c_CDS_onDB2Json;

//                                                                                                                                                =
// ======================  通过 Entity 转成 json ======================
@end

#define OBJ2JsonStretagy(skey, classT, stre, jsonClassT) skey : [[CLOJsonStretagyEntity alloc] initWithSubkey:skey \
                                                                                                    withClass:classT \
                                                                                                 withStretagy:stre \
                                                                                                withJsonClass:jsonClassT]
@interface CLOJsonStretagyEntity : CLOEntity


    @property (nonatomic,strong) NSString *mStrKey;
    @property (nonatomic,assign) eCLOJsonStretagy mEumStretagy;
    @property (nonatomic,strong) Class mClassType;
    @property (nonatomic,strong) Class mJsonClassType;


- (instancetype)initWithSubkey:(NSString *)skey
                     withClass:(Class)classT
                  withStretagy:(eCLOJsonStretagy)stre
                 withJsonClass:(Class)jsonClassT;

@end
