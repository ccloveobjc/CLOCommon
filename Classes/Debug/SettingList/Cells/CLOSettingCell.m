//
//  CLOSettingCell.m
//  CLOCommon
//
//  Created by Cc on 2019/8/13.
//

#import <CLOCommon/CLOCommonCore.h>
#import "CLOSettingCell.h"

@implementation CLOSettingEntity

- (CGFloat)gotItemHeight
{
    SDKAssert;
}

+ (Class)gotCellCalss
{
    SDKAssert;
}

+ (NSString *)gotCellName
{
    return NSStringFromClass([self.class gotCellCalss]);
}

+ (void)registerClass:(UICollectionView *)view
{
    Class cls = [self.class gotCellCalss];
    NSString *clstr = [self.class gotCellName];
    [view registerClass:cls forCellWithReuseIdentifier:clstr];
}

@end

@implementation CLOSettingCell

- (void)setupEntity:(CLOSettingEntity *)entity
{
    self.mEntity = entity;
}

@end
