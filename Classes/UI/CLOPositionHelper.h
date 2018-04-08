//
//  CLOPositionHelper.h
//  CLOCommon
//
//  Created by Cc on 2018/4/8.
//

#import <Foundation/Foundation.h>

#define kCLO_IS_IPHONEX (([[UIScreen mainScreen] bounds].size.height - 812) ? NO : YES)

@interface CLOPositionHelper : NSObject

/**
 获取状态栏的高度

 @return CGFloat
 */
+ (CGFloat)sGetStatusBarHeight;

/**
 获取iPhoneX的下边距离，如果是iPhoneX 返回一个固定值

 @return CGFloat
 */
+ (CGFloat)sGetiPhoneXBottomHeight;
@end
