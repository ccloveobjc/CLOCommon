//
//  CLOSettingBool.m
//  CLOCommon
//
//  Created by Cc on 2019/8/13.
//

#import <CLOCommon/CLOCommonUI.h>
#import "CLOSettingBool.h"

@implementation CLOSettingBoolEntity

+ (Class)gotCellCalss
{
    return CLOSettingBool.class;
}

- (CGFloat)gotItemHeight
{
    return 40;
}

@end

@interface CLOSettingBool ()

@property (nonatomic) UILabel *mUILabel;
@property (nonatomic) UISwitch *mUISwitch;

@end
@implementation CLOSettingBool

- (void)setupEntity:(__kindof CLOSettingEntity *)entity
{
    [super setupEntity:entity];
    
    if (!self.mUISwitch) {
        
        CGFloat w = 60;
        CGFloat h = 31;
        CGFloat y = (self.CLOHeight - h) / 2.0;
        self.mUISwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.CLOWidth - w, y, w, h)];
        [self.mUISwitch setTintColor:CLOColorMake(178, 58, 21, 1)];
        [self.mUISwitch setOnTintColor:[UIColor blueColor]];//31    153    88
//        [self.mUISwitch setThumbTintColor:CLOColorMake(255, 255, 255, 1)];//178    58    21
//        self.mUISwitch.layer.cornerRadius = 15.5f;
//        self.mUISwitch.layer.masksToBounds = YES;
        [self.mUISwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.mUISwitch];
    }
    
    if (!self.mUILabel) {
        
        self.mUILabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.mUISwitch.CLOLeft, [self.mEntity gotItemHeight])];
        [self.contentView addSubview:self.mUILabel];
    }
    
    [self.mUISwitch setOn:self.mEntity.mIsOn];
    self.mUILabel.text = self.mEntity.mTitleName;
}

- (void)switchAction:(UISwitch *)sender
{
    self.mEntity.mIsOn = sender.on;
    
    if (self.mEntity.mBoolSwitch) {
        
        self.mEntity.mBoolSwitch(self.mEntity);
    }
}
@end
