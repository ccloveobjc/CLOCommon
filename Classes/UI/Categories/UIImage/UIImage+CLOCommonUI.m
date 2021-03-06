//
//  UIImage+CLOCommonUI.m
//  CLOCommon
//
//  Created by Cc on 14/12/11.
//  Copyright (c) 2014年 PinguoSDK. All rights reserved.
//

#import "UIImage+CLOCommonUI.h"
#import "UIColor+CLOCommonUI.h"
#import <CLOCommon/CLOCommonCore.h>
#import <CoreVideo/CoreVideo.h>
//#include <string>
#import <CoreText/CoreText.h>

double cppCLODegreesToRadians(double degrees)
{
    return degrees * M_PI / 180;
}


double cppCLORadiansToDegrees(double radians)
{
    return radians * 180 / M_PI;
}


@implementation UIImage (CLOCommonUI)

+ (UIImage *)CLOGetImageByHexString:(NSString *)strHex withSize:(CGSize)size
{
    UIColor *aColor = [UIColor CLOGotColorByHexString:strHex withAlpha:1];
    if (aColor) {
        
        CGRect rectImage = CGRectMake(0.0f, 0.0f, size.width, size.height);
        UIGraphicsBeginImageContext(rectImage.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [aColor CGColor]);
        CGContextFillRect(context, rectImage);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    
    return nil;
}

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)CLOResizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality
{
    BOOL drawTransposed;
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self vc_common_ResizedImage:newSize
                              transform:[self vc_common_TransformForOrientation:newSize]
                         drawTransposed:drawTransposed
                   interpolationQuality:quality];
}

#pragma mark -
#pragma mark Private helper methods

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)vc_common_ResizedImage:(CGSize)newSize
                                  transform:(CGAffineTransform)transform
                             drawTransposed:(BOOL)transpose
                       interpolationQuality:(CGInterpolationQuality)quality
{
    UIImage *newImage = nil;
    if (newSize.width > 0 && newSize.height > 0) {
        
        CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
        CGRect transposedRect;
        
        if (transpose) {
            
            transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
        }
        else {
            
            transposedRect = CGRectMake(0, 0, newRect.size.width, newRect.size.height);
        }
        CGImageRef imageRef = self.CGImage;
        
        CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);

        // Build a context that's the same dimensions as the new size
        CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                    newRect.size.width,
                                                    newRect.size.height,
                                                    CGImageGetBitsPerComponent(imageRef),
                                                    0,
                                                    CGImageGetColorSpace(imageRef),
                                                    bitmapInfo);
        
        if (!bitmap && (bitmapInfo & kCGBitmapAlphaInfoMask) == kCGImageAlphaLast)
        {
            // WARNING - only do this if you expect a fully opaque image
            
            // try again with pre-multiply alpha
            
            // clear alpha bits
            bitmapInfo &= ~kCGBitmapAlphaInfoMask;
            // set pre-multiply last
            bitmapInfo |= kCGImageAlphaPremultipliedLast & kCGBitmapAlphaInfoMask;
            
            bitmap = CGBitmapContextCreate(NULL,
                                                        newRect.size.width,
                                                        newRect.size.height,
                                                        CGImageGetBitsPerComponent(imageRef),
                                                        0,
                                                        CGImageGetColorSpace(imageRef),
                                                        bitmapInfo);
        }
        
        // Rotate and/or flip the image if required by its orientation
        CGContextConcatCTM(bitmap, transform);
        
        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(bitmap, quality);
        
        CGContextSetShouldAntialias(bitmap, true);
        CGContextSetAllowsAntialiasing(bitmap, true);
        //CGContextSetFlatness(bitmap, 0);
        
        // Draw into the context; this scales the image
        //CGContextDrawTiledImage(bitmap, transposedRect, imageRef);
        CGContextDrawImage(bitmap, transposedRect, imageRef);
        
        // Get the resized image from the context and a UIImage
        CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
        newImage = [[UIImage alloc] initWithCGImage:newImageRef];
        
        // Clean up
        if (bitmap != NULL) {
            
            CFRelease(bitmap);
        }
        
        if (newImageRef != NULL) {
            
            CFRelease(newImageRef);
        }
    }
    else {
        
        SDKAssert;
    }
    
    return newImage;
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)vc_common_TransformForOrientation:(CGSize)newSize
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    UIImageOrientation iOrien = self.imageOrientation;
    switch (iOrien)
    {
        case UIImageOrientationUp:
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationDown:
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI);
            break;
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (iOrien)
    {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}

- (UIImage *)CLOFixImageByOrientation
{
    if (self.imageOrientation != UIImageOrientationUp) {
        
        SDKLog(@"c_common_FixImageByOrientation size:%@", NSStringFromCGSize(self.size))
        return [self CLORotation:self.imageOrientation];
    }
    else {
        
        SDKErrorLog(@"c_common_FixImageByOrientation 没有矫正! size:%@", NSStringFromCGSize(self.size))
        return self;
    }
}

- (UIImage *)CLORotation:(UIImageOrientation)oOrientation
{
    UIImageOrientation imageOrientation = oOrientation;
    CGImageRef imgRef = self.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = imageOrientation;
    switch (orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            NSAssert(NO, @"@Invalid image orientation");
            break;
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

- (UIImage *)CLOGotScameImageWithMaxPixels:(long)maxPixel
{
    //根据最大像素计算缩放的宽度
    CGSize imageSize = self.size;
    
    if (imageSize.width * imageSize.height <= maxPixel)
    {
        //没有超过最大像素，不需要缩放，直接返回原图
        SDKErrorLog(@"c_common_GotScameImageWithMaxPixels 没有进行任何压缩，直接返回原图!");
        return self;
    }
    
    CGFloat newWidth = sqrtf(maxPixel * imageSize.width / imageSize.height);
    
    CGFloat newHeight = newWidth / imageSize.width * imageSize.height;
    
    return [self CLOResizedImage:CGSizeMake(newWidth, newHeight)
                  interpolationQuality:kCGInterpolationHigh];
}

- (UIImage *)CLORotatedByDegrees:(CGFloat)degrees
{
    @autoreleasepool
    {
        // calculate the size of the rotated view's containing box for our drawing space
        // REV @ppg 这里可能被异步调用,然后崩溃, 非线程安全
        UIImage *srcImage = self;
        UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, srcImage.size.width, srcImage.size.height)];
        CGAffineTransform t = CGAffineTransformMakeRotation(cppCLODegreesToRadians(degrees));
        rotatedViewBox.transform = t;
        CGSize rotatedSize = rotatedViewBox.frame.size;
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize);
        CGContextRef bitmap = UIGraphicsGetCurrentContext();
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, rotatedSize.width / 2, rotatedSize.height / 2);
        
        //   // Rotate the image context
        CGContextRotateCTM(bitmap, cppCLODegreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        CGContextScaleCTM(bitmap, 1.0, -1.0);
        CGContextDrawImage(bitmap,
                           CGRectMake(-srcImage.size.width / 2,
                                      -srcImage.size.height / 2,
                                      srcImage.size.width,
                                      srcImage.size.height),
                           [srcImage CGImage]);
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
}

- (unsigned long)CLOGotSDKMakeMaxPixelsWithLimit:(unsigned long)limitPixel
{
    UIImage *oriImage = self;
    CGFloat dMaxSidePixel = 4096;
    CGFloat dPixelOne = 0;
    CGFloat biImage = oriImage.size.width / oriImage.size.height;
    if (biImage > 1) {
        
        CGFloat biW = oriImage.size.width > dMaxSidePixel ? dMaxSidePixel : oriImage.size.width;
        CGFloat biH = biW / biImage;
        dPixelOne = biW * biH;
    }
    else if (biImage < 1) {
        
        CGFloat biH = oriImage.size.height > dMaxSidePixel ? dMaxSidePixel : oriImage.size.height;
        CGFloat biW = biH * biImage;
        dPixelOne = biW * biH;
    }
    else { // biImage == 1
        
        CGFloat biW = oriImage.size.width > dMaxSidePixel ? dMaxSidePixel : oriImage.size.width;
        CGFloat biH = biW;
        dPixelOne = biW * biH;
    }
    
    if (limitPixel > 0) {
        
        dPixelOne = dPixelOne < limitPixel ? dPixelOne : limitPixel;
    }
    
    return dPixelOne;
}

- (CGSize)CLOGotMoreThanLimit:(CGSize)size
{
    CGFloat newBZ = self.size.width / self.size.height;
    NSInteger newW = self.size.width;
    NSInteger newH = self.size.height;
    
    if (size.width < newW) {
        
        newW = size.width;
        newH = newW / newBZ;
    }
    
    if (size.height < newH) {
        
        newH = size.height;
        newW = newH * newBZ;
    }
    
    return CGSizeMake(newW, newH);
}

+ (CMSampleBufferRef)CLOSampleBufferFromCGImage:(CGImageRef)image
{
    CVPixelBufferRef pixelBuffer = [UIImage vc_common_PixelBufferFromCGImage:image];
    CMSampleBufferRef newSampleBuffer = NULL;
    CMSampleTimingInfo timimgInfo = kCMTimingInfoInvalid;
    CMVideoFormatDescriptionRef videoInfo = NULL;
    CMVideoFormatDescriptionCreateForImageBuffer(NULL, pixelBuffer, &videoInfo);
    CMSampleBufferCreateForImageBuffer(kCFAllocatorDefault,
                                       pixelBuffer,
                                       true,
                                       NULL,
                                       NULL,
                                       videoInfo,
                                       &timimgInfo,
                                       &newSampleBuffer);
    
    CVPixelBufferRelease(pixelBuffer);
    return newSampleBuffer;
}

+ (CVPixelBufferRef)vc_common_PixelBufferFromCGImage:(CGImageRef)image
{
    CGSize frameSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
    
    NSDictionary *options = @{
                              (id)kCVPixelBufferIOSurfacePropertiesKey : @{
                                      (id)kCVPixelBufferCGImageCompatibilityKey : @YES,
                                      (id)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES
                                      }
                              };

    
    CVPixelBufferRef pxbuffer = NULL;
    
    CVReturn status = CVPixelBufferCreate( kCFAllocatorDefault,
                                          frameSize.width,
                                          frameSize.height,
                                          kCVPixelFormatType_32BGRA,
                                          (__bridge CFDictionaryRef)options,
                                          &pxbuffer );
    
    if (status != kCVReturnSuccess) {
        
        SDKAssertionLog(status == kCVReturnSuccess && pxbuffer != NULL, @"");
    }
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(
                                                 pxdata, frameSize.width, frameSize.height,
                                                 8, CVPixelBufferGetBytesPerRow(pxbuffer),
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGBitmapByteOrder32Little |
                                                 kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

+ (CGImageRef)CLOCGImageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    CGImageRef newImage = NULL;
    
//    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    CVPixelBufferLockBaseAddress(imageBuffer, 0);        // Lock the image buffer
//    {
//        uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);   // Get information of the image
//        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
//        size_t width = CVPixelBufferGetWidth(imageBuffer);
//        size_t height = CVPixelBufferGetHeight(imageBuffer);
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//        {
//            CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
            CGContextRef newContext = [self.class CLOCGContextFromSampleBuffer:sampleBuffer];
            {
                newImage = CGBitmapContextCreateImage(newContext);
            }
            CGContextRelease(newContext);
//        }
//        CGColorSpaceRelease(colorSpace);
//    }
//    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    /* CVBufferRelease(imageBuffer); */  // do not call this!
    
    return (__bridge CGImageRef)CFBridgingRelease(newImage);
}

+ (CGContextRef)CLOCGContextFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    CGContextRef newContext = NULL;
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);        // Lock the image buffer
    {
        uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);   // Get information of the image
        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        {
            newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
        }
        CGColorSpaceRelease(colorSpace);
    }
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    return newContext;
}


- (NSData *)CLOGotBytesFromCGImageWithOutWidth:(NSUInteger *)widthPtr
                                       withOutHeight:(NSUInteger *)heightPtr
{
    CGImageRef cgImage = self.CGImage;
    SDKAssertionLog(NULL != cgImage, @"");
    SDKAssertionLog(NULL != widthPtr, @"");
    SDKAssertionLog(NULL != heightPtr, @"");
    
    size_t originalWidth = CGImageGetWidth(cgImage);
    size_t originalHeight = CGImageGetHeight(cgImage);
    
    SDKAssertionLog(0 < originalWidth, @"Invalid image width");
    SDKAssertionLog(0 < originalHeight, @"Invalid image height");
    
    size_t width = originalWidth;
    size_t height = originalHeight;
    
    NSMutableData *imageData = [NSMutableData dataWithLength: height * width * 4];
    
    SDKAssertionLog(nil != imageData, @"Unable to allocate image storage");
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    {
        CGContextRef cgContext = CGBitmapContextCreate([imageData mutableBytes]
                                                       , width
                                                       , height
                                                       , 8
                                                       , 4 * width
                                                       , colorSpace
                                                       , (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
        {
            CGContextDrawImage(cgContext, CGRectMake(0, 0, width, height), cgImage);
        }
        CGContextRelease(cgContext);
    }
    CGColorSpaceRelease(colorSpace);
    
    
    *widthPtr = (NSUInteger)width;
    *heightPtr = (NSUInteger)height;
    
    return imageData;
}

+ (UIImage *)CLOImageWithColor:(UIColor *)color
                                size:(CGSize)size
                        cornerRadius:(CGFloat)cornerRadius
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//+ (unsigned char *_Nullable)c_common_GotImageData:(nonnull NSString *)imgPath withW:(int&)sw withH:(int&)sh
//{
//    unsigned char *pData = nullptr;
//    NSString *pFile = imgPath;
//    CGDataProviderRef ref = CGDataProviderCreateWithFilename([pFile UTF8String]);
//    {
//        CGImageRef imgRef= CGImageCreateWithPNGDataProvider(ref, NULL, false, kCGRenderingIntentDefault);
//        {
//            CFDataRef dataRef = CGDataProviderCopyData(CGImageGetDataProvider(imgRef));
//            {
//                CFIndex size = CFDataGetLength(dataRef);
//                pData = new unsigned char[size];
//                unsigned char *pP = (UInt8 *) CFDataGetBytePtr(dataRef);
//                memcpy(pData, pP, size);
//                
//                sw = (int)CGImageGetWidth(imgRef);
//                sh = (int)CGImageGetHeight(imgRef);
//            }
//            CFRelease(dataRef);
//        }
//        CGImageRelease(imgRef);
//    }
//    CGDataProviderRelease(ref);
//    
//    return pData;
//}
//+ (BOOL)c_common_GotImageInData:(nonnull UIImage *)img withData:(unsigned char *_Nonnull)pData
//{
//    int w,h;
//    w = (int)CGImageGetWidth(img.CGImage);
//    h = (int)CGImageGetHeight(img.CGImage);
//    
//    CGImageRef imgRef=[img CGImage];
//    NSUInteger bytesPerPixel = 4;
//    NSUInteger bytesPerRow = bytesPerPixel * w;
//    NSUInteger bitsPerComponent = 8;
//    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    //    CGContextRef context = CGBitmapContextCreate(pData, w, h,
//    //												 bitsPerComponent, bytesPerRow, colorSpace,
//    //												 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
//    CGContextRef context = CGBitmapContextCreate(pData, w, h,
//                                                 bitsPerComponent, bytesPerRow, colorSpace,
//                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//    
//    CGContextDrawImage(context, CGRectMake(0, 0, w, h), imgRef);
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    
//    //RGBA转为BGRA
//    unsigned char r,g,b,*p=pData;
//    for (int y=0; y<h; y++) {
//        for (int x=0; x<w; x++)
//        {
//            r=p[0];
//            g=p[1];
//            b=p[2];
//            
//            p[0]=b;
//            p[1]=g;
//            p[2]=r;
//            
//            p+=4;
//        }
//    }
//    
//    return true;
//}

+ (CMSampleBufferRef)CLODrawSampleBufferFacePoints:(CMSampleBufferRef)sampleBuffer withPoints:(NSArray<NSArray<NSValue *> *> *)faces
{
    CGImageRef newImage = NULL;
    {
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CVPixelBufferLockBaseAddress(imageBuffer, 0);        // Lock the image buffer
        {
            uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);   // Get information of the image
            size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
            size_t width = CVPixelBufferGetWidth(imageBuffer);
            size_t height = CVPixelBufferGetHeight(imageBuffer);
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            {
                CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
                {
                    CGContextSetLineWidth(newContext, fmax(width, height)/1000.0*2.0);
                    
                    for (NSArray<NSValue *> *face in faces) {
                        
                        for (NSValue *point in face) {
                            
                            CGPoint pt = [point CGPointValue];
                            CGContextAddRect(newContext, CGRectMake(pt.x , height - pt.y , 0.5 , 0.5));
                        }
                    }
                    
                    CGContextSetRGBStrokeColor(newContext, 0.0, 1.0, 0.0, 1.0);
                    CGContextStrokePath(newContext);
                    
                    newImage = CGBitmapContextCreateImage(newContext);
                }
                CGContextRelease(newContext);
            }
            CGColorSpaceRelease(colorSpace);
        }
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    }
    /* CVBufferRelease(imageBuffer); */  // do not call this!
    
    
    CMSampleBufferRef newSampleBuffer = NULL;
    {
        CVPixelBufferRef pixelBuffer = [UIImage vc_common_PixelBufferFromCGImage:newImage];
        CMSampleTimingInfo timimgInfo = kCMTimingInfoInvalid;
        timimgInfo.decodeTimeStamp = CMSampleBufferGetDecodeTimeStamp(sampleBuffer);
        timimgInfo.duration = CMSampleBufferGetDuration(sampleBuffer);
        timimgInfo.presentationTimeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        
        CMVideoFormatDescriptionRef videoInfo = NULL;
        CMVideoFormatDescriptionCreateForImageBuffer( NULL, pixelBuffer, &videoInfo);
        CMSampleBufferCreateForImageBuffer(kCFAllocatorDefault,
                                           pixelBuffer,
                                           true,
                                           NULL,
                                           NULL,
                                           videoInfo,
                                           &timimgInfo,
                                           &newSampleBuffer);
        
        CFRelease(pixelBuffer);
    }
    
    CFRelease(newImage);
    
    return newSampleBuffer;
}

+ (UIImage *)CLODrawUIImageFacePoints:(UIImage *)oriImage withPoints:(NSArray<NSArray<NSValue *> *> *)faces
{
    if (faces.count == 0) {
        
        return oriImage;
    }
    
    UIImage *imgRet = nil;
    int w,h;
    w = (int)CGImageGetWidth(oriImage.CGImage);
    h = (int)CGImageGetHeight(oriImage.CGImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    {
        CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
        {
            CGContextDrawImage(context, CGRectMake(0, 0, w, h), oriImage.CGImage);
            
            CGContextSetLineWidth(context, fmax(w, h)/1000.0*2.0);
            
            for (NSArray<NSValue *> *face in faces) {
                
                for (NSValue *point in face) {
                    
                    CGPoint pt = [point CGPointValue];
                    CGContextAddRect(context, CGRectMake(pt.x, h - pt.y, 0.5, 0.5));
                }
            }
            
            CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
            CGContextStrokePath(context);
            
            CGImageRef newImage = CGBitmapContextCreateImage(context);
            imgRet = [UIImage imageWithCGImage:newImage];
            CGImageRelease(newImage);
        }
        CGContextRelease(context);
    }
    CGColorSpaceRelease(colorSpace);
    
    return imgRet;
}

- (UIImage *)CLOWriteWords:(NSString *)strText
{
    UIImage *img = self;
    int w = img.size.width;
    
    int h = img.size.height;
    
    //lon = h - lon;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    
//    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1);
    
    
    char* text  = (char *)[strText cStringUsingEncoding:NSASCIIStringEncoding];// "05/05/09";
    
    CGContextSelectFont(context, "Arial", 18, kCGEncodingMacRoman);
    
    CGContextSetTextDrawingMode(context, kCGTextFill);
    
    CGContextSetRGBFillColor(context, 255, 0, 0, 1);
    
    
    
    //rotate text
    
//    CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( -M_PI/4 ));
    
    
    CGContextShowTextAtPoint(context, 10, h - 20, text, strlen(text));
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    CGColorSpaceRelease(colorSpace);
    
    
    return [UIImage imageWithCGImage:imageMasked];
}

+ (void)CLOGotBytesFromSampleBuffer:(CMSampleBufferRef)sampleBuffer withBlock:(void (^)(unsigned char *pData, int w, int h))block
{
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    int bufferWidth = (int)CVPixelBufferGetWidth(pixelBuffer);
    int bufferHeight = (int)CVPixelBufferGetHeight(pixelBuffer);
    
    unsigned char *pData=(unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
    
    block(pData, bufferWidth, bufferHeight);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
}

+ (UIImage *)CLOCreateImageByDictionary:(NSDictionary *)params
{
    NSArray *paramsKey = [params.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
       
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    int step = 20;
    int w = 500;
    int h = 0;
    h+= step * paramsKey.count;
    h+= 5 + 5;
    h+= 50;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathStroke);
    
    int index = 0;
    for (NSString *key in paramsKey) {
        
        NSString *strText = nil;
        id param = params[key];
        if ([param isKindOfClass:[NSString class]]) {
            
            strText = param;
        }
        else if ([param isKindOfClass:[NSNumber class]]) {
            
            strText = [[NSString alloc] initWithFormat:@"%@", param];
        }
        else if ([param isKindOfClass:[NSArray class]]) {
            
            NSMutableString *strSub = [[NSMutableString alloc] init];
            for (id x in param) {
                
                [strSub appendFormat:@"%@,", x];
            }
            strText = strSub;
        }
        else {
            
            SDKAssert;
        }
        
        NSString *strAll = [[NSString alloc] initWithFormat:@"%@ = %@", key, strText];
        [strAll drawAtPoint:(CGPointMake(30, index * step + 5)) withAttributes:@{
                                                                            NSFontAttributeName : [UIFont systemFontOfSize:18],
                                                                            NSForegroundColorAttributeName : [UIColor blackColor],
                                                                            }];
        index ++;
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)CLOCropImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

- (UIImage *)CLOEqualRatioToSize:(CGSize)size withUsingSizeDrawContext:(BOOL)isUsing
{
    float width = CGImageGetWidth(self.CGImage);
    float height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio > 1 && horizontalRadio > 1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = (int)(width * radio);
    height = (int)(height * radio);
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    if (isUsing) {
    
        UIGraphicsBeginImageContext(size);
        // 绘制改变大小的图片
        int xPos = (size.width - width)/2;
        int yPos = (size.height-height)/2;
        [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    }
    else {
        
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        [self drawInRect:CGRectMake(0, 0, width, height)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}
@end
