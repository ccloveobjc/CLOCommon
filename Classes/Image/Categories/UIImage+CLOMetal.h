//
//  UIImage+CLOMetal.h
//  CLOCommon
//
//  Created by Cc on 2019/7/30.
//

#import <UIKit/UIKit.h>
#import <MetalKit/MetalKit.h>
#import <Accelerate/Accelerate.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CLOMetal)

+ (UIImage *)CLOImageWithMTLTexture:(id<MTLTexture>)texture;

+ (CVPixelBufferRef)CLOMTLTextureToPixelBuffer:(id<MTLTexture>)texture;

+ (unsigned char *)CLOMTLTextureToBytes:(id<MTLTexture>)texture;

/**
 注意，需要自行释放这个返回
 使用 malloc() 的方式创建，需要用 free() 的方式释放
 */
+ (unsigned char *)CLOConvertUIImageToBitmapRGBA8:(UIImage *)image withOutPerRow:(size_t *)oBytesPerRow;
+ (unsigned char *)CLOConvertUIImageToBitmapRGBA8:(UIImage *)image withOutPerRow:(size_t *)oBytesPerRow withOutWidth:(size_t *)oW withOutHeight:(size_t *)oH;

/**
 需要自行释放这个返回
 使用 CGContextRelease() 的方式释放
 */
+ (CGContextRef)CLONewBitmapRGBA8ContextFromImage:(CGImageRef)image;

/**
  把RAW裸数据变成UIImage，bytesPerPixel指它是多少通道的，灰度图就是1，RGB就是3，RGBA就是4
 */
+ (UIImage *)CLOCreateRGBAImage:(unsigned char *)pixelDataX withBytesPerPixel:(NSUInteger)bytesPerPixel width:(NSUInteger)w height:(NSUInteger)h;

+ (UIImage *)CLOMergeRGBAImage:(UIImage *)oriImg withMaskImage:(UIImage *)maskImg withBlendColor:(nullable UIColor *)detColor;

+ (UIImage *)CLOMergeRGBAData:(NSData *)ori withMaskData:(NSData *)mask withBlendColor:(nullable UIColor *)detColor;

@end

NS_ASSUME_NONNULL_END
