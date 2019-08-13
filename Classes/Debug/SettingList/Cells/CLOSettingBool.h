//
//  CLOSettingBool.h
//  CLOCommon
//
//  Created by Cc on 2019/8/13.
//

#import "CLOSettingCell.h"

NS_ASSUME_NONNULL_BEGIN

@class CLOSettingBoolEntity;

typedef void (^bCLOSettingBoolSwitch)(CLOSettingBoolEntity *sender);

@interface CLOSettingBoolEntity : CLOSettingEntity

@property (nonatomic) NSString *mTitleName;
@property (nonatomic) BOOL mIsOn;
@property (nonatomic, copy) bCLOSettingBoolSwitch mBoolSwitch;

@end

// -----------------------------Cell view -----------------------------------

@interface CLOSettingBool : CLOSettingCell

@property (nonatomic) __kindof CLOSettingBoolEntity *mEntity;

@end

NS_ASSUME_NONNULL_END
