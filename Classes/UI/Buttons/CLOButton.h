//
//  CLOButton.h
//  CLOCommon
//
//  Created by Cc on 14-5-13.
//  Copyright (c) 2014年 Pinguo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^tCLOButtonClick)(id sender);

@interface CLOButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)strTitle withClick:(tCLOButtonClick)clickBlock;

@end

NS_ASSUME_NONNULL_END
