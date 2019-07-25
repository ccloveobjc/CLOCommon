//
//  UIView+CLOLayout.m
//  CLOCommon
//
//  Created by Cc on 2019/7/23.
//

#import "UIView+CLOLayout.h"

@implementation UIView (CLOLayout)

@dynamic CLOTop;
@dynamic CLOBottom;
@dynamic CLOLeft;
@dynamic CLORight;

@dynamic CLOWidth;
@dynamic CLOHeight;

@dynamic CLOSize;

@dynamic CLOX;
@dynamic CLOY;

- (CGFloat)CLOTop
{
    return self.frame.origin.y;
}

- (void)setCLOTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)CLOLeft
{
    return self.frame.origin.x;
}

- (void)setCLOLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)CLOBottom
{
    return self.frame.size.height + self.frame.origin.y;
}

- (void)setCLOBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)CLORight
{
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setCLORight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)CLOX
{
    return self.frame.origin.x;
}

- (void)setCLOX:(CGFloat)value
{
    CGRect frame = self.frame;
    frame.origin.x = value;
    self.frame = frame;
}

- (CGFloat)CLOY
{
    return self.frame.origin.y;
}

- (void)setCLOY:(CGFloat)value
{
    CGRect frame = self.frame;
    frame.origin.y = value;
    self.frame = frame;
}

- (CGPoint)CLOOrigin
{
    return self.frame.origin;
}

- (void)setCLOOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)CLOCenterX
{
    return self.center.x;
}

- (void)setCLOCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)CLOCenterY
{
    return self.center.y;
}

- (void)setCLOCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)CLOWidth
{
    return self.frame.size.width;
}

- (void)setCLOWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)CLOHeight
{
    return self.frame.size.height;
}

- (void)setCLOHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)CLOSize
{
    return self.frame.size;
}

- (void)setCLOSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end
