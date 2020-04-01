//
//  CLOSettingButton.m
//  CLOCommon
//
//  Created by Cc on 2019/8/13.
//

#import <CLOCommon/CLOCommonUI.h>
#import "CLOSettingButton.h"
#import "CLOButton.h"

@implementation CLOSettingButtonEntity

+ (Class)gotCellCalss
{
    return CLOSettingButton.class;
}

- (CGFloat)gotItemHeight
{
    return 50;
}

@end


@interface CLOSettingButton ()

@property (nonatomic) CLOButton *mCLOButton;

@end
@implementation CLOSettingButton

@synthesize mEntity;

- (void)setupEntity:(__kindof CLOSettingEntity *)entity
{
    [super setupEntity:entity];
    
    [self.mCLOButton setupTitle:self.mEntity.mButtonName];
    
    if (!self.mCLOButton) {
        @CLOWS
        self.mCLOButton = [[CLOButton alloc] initWithFrame:self.bounds withTitle:self.mEntity.mButtonName withClick:^(id  _Nonnull sender) {
            @CLOSS
            if (self.mEntity.mButtonClick) {
                
                self.mEntity.mButtonClick(self);
            }
        }];
        [self.contentView addSubview:self.mCLOButton];
    }
}
@end
