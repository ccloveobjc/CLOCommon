//
//  CLOSettingCell.h
//  CLOCommon
//
//  Created by Cc on 2019/8/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CLOSettingEntity;

@interface CLOSettingEntity : NSObject

- (CGFloat)gotItemHeight;

+ (Class)gotCellCalss;

+ (NSString *)gotCellName;

+ (void)registerClass:(UICollectionView *)view;

@end

@interface CLOSettingCell : UICollectionViewCell

@property (nonatomic) __kindof CLOSettingEntity *mEntity;

- (void)setupEntity:(__kindof CLOSettingEntity *)entity;

@end

NS_ASSUME_NONNULL_END
