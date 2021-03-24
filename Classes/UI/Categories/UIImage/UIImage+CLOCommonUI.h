//
//  UIImage+CLOCommonUI.h
//  CLOCommon
//
//  Created by Cc on 14/12/11.
//  Copyright (c) 2014年 PinguoSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>


    // C++
    double cppCLODegreesToRadians(double degrees);
    double cppCLORadiansToDegrees(double radians);

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CLOCommonUI)

+ (nullable UIImage *)CLOGetImageByHexString:(NSString *)strHex withSize:(CGSize)size;
// kCGInterpolationDefault 比较好的压缩
- (UIImage *)CLOResizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)CLOFixImageByOrientation;

- (UIImage *)CLORotation:(UIImageOrientation)oOrientation;

- (UIImage *)CLOGotScameImageWithMaxPixels:(long)maxPixel;

- (UIImage *)CLORotatedByDegrees:(CGFloat)degrees;


/**
 *  获取sdk最大支持像素
 *  如果参数 limitPixel ＝ 0 那么这个参数不起作用
 */
- (unsigned long)CLOGotSDKMakeMaxPixelsWithLimit:(unsigned long)limitPixel;

/**
 *  获取不大于这个尺寸的最大值，并且保持比列
 */
- (CGSize)CLOGotMoreThanLimit:(CGSize)size;


    + (_Nullable CMSampleBufferRef)CLOSampleBufferFromCGImage:(CGImageRef)image;

    + (_Nullable CGImageRef)CLOCGImageFromSampleBuffer:(CMSampleBufferRef)buffer;

    + (_Nullable CGContextRef)CLOCGContextFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;


/**
 *  获取UIImage 对应的 char *
 */
- (nullable NSData *)CLOGotBytesFromCGImageWithOutWidth:(NSUInteger *)widthPtr
                                          withOutHeight:(NSUInteger *)heightPtr;


    + (nullable UIImage *)CLOImageWithColor:(UIColor *)color
                                       size:(CGSize)size
                               cornerRadius:(CGFloat)cornerRadius;


///**
// 获取路径的图片格式转成char *
//
// @param imgPath 路径
// @param sw 输出W
// @param sh 输出H
// @return char* 需要自行delete []
// */
//+ (unsigned char *_Nullable)c_common_GotImageData:(nonnull NSString *)imgPath withW:(int&)sw withH:(int&)sh;
//+ (BOOL)c_common_GotImageInData:(nonnull UIImage *)img withData:(unsigned char *_Nonnull)pData;

    + (_Nullable CMSampleBufferRef)CLODrawSampleBufferFacePoints:(CMSampleBufferRef)sampleBuffer withPoints:(NSArray<NSArray<NSValue *> *> *)faces;
    + (nullable UIImage *)CLODrawUIImageFacePoints:(UIImage *)oriImage withPoints:(NSArray<NSArray<NSValue *> *> *)faces;


/**
 图片上写字

 @param strText 文字
 @return 图片
 */
- (nullable UIImage *)CLOWriteWords:(NSString *)strText CG_AVAILABLE_BUT_DEPRECATED(10.0, 10.9, 2.0, 7.0);


/**
 获取buffer 的 RGBA 格式的Data

 @param sampleBuffer 预览帧
 */
+ (void)CLOGotBytesFromSampleBuffer:(CMSampleBufferRef)sampleBuffer withBlock:(void (^)(unsigned char *pData, int w, int h))block;


/**
 把dictionary 上的信息写到图片上

 @param params 支持 NSNumber ,NSArry , NSString
 @return 图片
 */
+ (UIImage *)CLOCreateImageByDictionary:(NSDictionary *)params;


/**
 裁剪图片

 @param rect 位置
 @return 新图
 */
- (UIImage *)CLOCropImage:(CGRect)rect;

/**
 等比缩放

 @param size 最大
 @return 图
 */
- (UIImage *)CLOEqualRatioToSize:(CGSize)size withUsingSizeDrawContext:(BOOL)isUsing;
@end
NS_ASSUME_NONNULL_END
