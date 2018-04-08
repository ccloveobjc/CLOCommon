//
//  CLOLogMgr.h
//  CLOAlbum
//
//  Created by Cc on 2018/1/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kCLOColor(r, g, b, a) [CLOColorHelper fColorRed:(r) withGreen:(g) withBlue:(b) withAlpha:(a)]

@interface CLOColorHelper : NSObject

/**
 获取 UIColor

 @param red 0 - 255
 @param green 0 - 255
 @param blue 0 - 255
 @param alpha 0 - 1
 @return UIColor
 */
+ (UIColor *)fColorRed:(NSInteger)red withGreen:(NSInteger)green withBlue:(NSInteger)blue withAlpha:(CGFloat)alpha;

@end
