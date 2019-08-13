//
//  CLOSettingButton.h
//  CLOCommon
//
//  Created by Cc on 2019/8/13.
//

#import "CLOSettingCell.h"

NS_ASSUME_NONNULL_BEGIN

@class CLOSettingButton;

typedef void (^bCLOSettingButtonClick)(CLOSettingButton *sender);

@interface CLOSettingButtonEntity : CLOSettingEntity

@property (nonatomic) NSString *mButtonName;
@property (nonatomic, copy) bCLOSettingButtonClick mButtonClick;

@end

// -----------------------------Cell view -----------------------------------

@interface CLOSettingButton : CLOSettingCell

@property (nonatomic) __kindof CLOSettingButtonEntity *mEntity;

@end

NS_ASSUME_NONNULL_END
