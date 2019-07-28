//
//  CLOButton.m
//  CLOCommon
//
//  Created by Cc on 14-5-13.
//  Copyright (c) 2014年 Pinguo. All rights reserved.
//

#import "CLOButton.h"

@interface CLOButton ()

@property (nonatomic,copy) tCLOButtonClick mClickBlock;
@property (nonatomic) UIColor *mNormalColor;
@property (nonatomic) UIColor *mHighlightedColor;

@end
@implementation CLOButton

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)strTitle withClick:(tCLOButtonClick)clickBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _mNormalColor = [UIColor blueColor];
        _mHighlightedColor = [UIColor brownColor];
        
        [self setTitle:strTitle forState:UIControlStateNormal];
        [self setTitleColor:_mNormalColor forState:(UIControlStateNormal)];
        [self setTitleColor:_mHighlightedColor forState:(UIControlStateHighlighted)];
        [self addTarget:self action:@selector(onClick:) forControlEvents:(UIControlEventTouchUpInside)];
        self.mClickBlock = clickBlock;
        
        //设置边框的颜色
        [self.layer setBorderColor:_mNormalColor.CGColor];
        //设置边框的粗细
        [self.layer setBorderWidth:2.0];
        //设置圆角的半径
        [self.layer setCornerRadius:12];
        //切割超出圆角范围的子视图
        self.layer.masksToBounds = YES;
        
        
    }
    return self;
}

- (void)dealloc
{
    self.mClickBlock = nil;
    [self removeTarget:self action:nil forControlEvents:(UIControlEventAllEvents)];
}

- (void)onClick:(id)sender
{
    if (self.mClickBlock) {
        
        self.mClickBlock(sender);
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        
        [self.layer setBorderColor:_mHighlightedColor.CGColor];
    }
    else {
        
        [self.layer setBorderColor:_mNormalColor.CGColor];
    }
}

@end
