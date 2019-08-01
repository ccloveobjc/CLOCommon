//
//  UIImage+CLOMetal.h
//  CLOCommon
//
//  Created by Cc on 2019/7/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CLOMetal)

+ (UIImage *)CLOImageWithMTLTexture:(id<MTLTexture>)texture;

+ (UIImage *)CLOxxxxxx:(id<MTLTexture>)texture;

+ (CVPixelBufferRef)CLOxx:(id<MTLTexture>)texture;
@end

NS_ASSUME_NONNULL_END
