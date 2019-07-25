//
//  UIView+CLOLayout.h
//  CLOCommon
//
//  Created by Cc on 2019/7/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CLOLayout)

@property (assign, nonatomic) CGFloat CLOTop;
@property (assign, nonatomic) CGFloat CLOBottom;
@property (assign, nonatomic) CGFloat CLOLeft;
@property (assign, nonatomic) CGFloat CLORight;

@property (assign, nonatomic) CGFloat CLOX;
@property (assign, nonatomic) CGFloat CLOY;
@property (assign, nonatomic) CGPoint CLOOrigin;

@property (assign, nonatomic) CGFloat CLOCenterX;
@property (assign, nonatomic) CGFloat CLOCenterY;

@property (assign, nonatomic) CGFloat CLOWidth;
@property (assign, nonatomic) CGFloat CLOHeight;
@property (assign, nonatomic) CGSize  CLOSize;

@end

NS_ASSUME_NONNULL_END
