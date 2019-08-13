//
//  CLOSettingView.m
//  CLOCommon
//
//  Created by Cc on 2019/8/13.
//

#import <CLOCommon/CLOCommonUI.h>
#import "CLOSettingView.h"
#import "CLOSettingBool.h"
#import "CLOSettingButton.h"

@interface CLOSettingView ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic) NSArray<__kindof CLOSettingEntity *> *mEntities;

@end

@implementation CLOSettingView

- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [CLOSettingBoolEntity registerClass:self];
        [CLOSettingButtonEntity registerClass:self];
        
        self.delegate = self;
        self.dataSource = self;
        
        self.mMinimumLineSpacing = 10;
    }
    return self;
}

- (void)setupEntities:(NSArray<__kindof CLOSettingEntity *> *)entities
{
    self.mEntities = entities;
    
    [self reloadData];
}

#pragma make UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mEntities.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CLOSettingEntity *ety = self.mEntities[indexPath.item];
    NSString *clstr = [ety.class gotCellName];
    CLOSettingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:clstr forIndexPath:indexPath];
//    //在这里进行各种操作
//    cell.contentView.backgroundColor = [UIColor blueColor];
    [cell setupEntity:ety];
    
    return cell;
}
#pragma make UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = self.CLOWidth - 2 * self.mMinimumLineSpacing;
    CGFloat h = [self.mEntities[indexPath.item] gotItemHeight];
    return CGSizeMake(w, h);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    // top,  left,  bottom,  right
    CGFloat cv = self.mMinimumLineSpacing;
    return UIEdgeInsetsMake(0, cv, 0, cv);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.mMinimumLineSpacing;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.bSelectedItem) {
//
//        self.bSelectedItem(self.mDatasource[indexPath.item]);
//    }
//}
@end
