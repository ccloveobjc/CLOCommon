//
//  CLOSettingView.h
//  CLOCommon
//
//  Created by Cc on 2019/8/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CLOSettingEntity;

@interface CLOSettingView : UICollectionView

@property (nonatomic) CGFloat mMinimumLineSpacing;

- (void)setupEntities:(NSArray<__kindof CLOSettingEntity *> *)entities;

@end

NS_ASSUME_NONNULL_END
