//
//  UIImage+CLOMetal.m
//  CLOCommon
//
//  Created by Cc on 2019/7/30.
//

#import "UIImage+CLOMetal.h"
#import <CLOCommon/CLOCommonCore.h>
#import <CoreVideo/CoreVideo.h>

@implementation UIImage (CLOMetal)

static void CLOMetalReleaseDataCallback(void *info, const void *data, size_t size)
{
    free(data);
}
static void CLOCGBitmapContextReleaseDataCallback(void * __nullable releaseInfo, void * __nullable data)
{
    free(data);
}

+ (UIImage *)CLOImageWithMTLTexture:(id<MTLTexture>)texture
{
//    SDKAssert([texture pixelFormat] == MTLPixelFormatBGRA8Unorm, @"Pixel format of texture must be MTLPixelFormatBGRA8Unorm to create UIImage");
    UIImage *image = nil;
    @autoreleasepool {
        
        CGSize imageSize = CGSizeMake([texture width], [texture height]);
        size_t imageByteCount = imageSize.width * imageSize.height * 4;
        void *imageBytes = malloc(imageByteCount);// 在 CLOMetalReleaseDataCallback 方法中销毁
        NSUInteger bytesPerRow = imageSize.width * 4;
        MTLRegion region = MTLRegionMake2D(0, 0, imageSize.width, imageSize.height);
        [texture getBytes:imageBytes bytesPerRow:bytesPerRow fromRegion:region mipmapLevel:0];
        CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imageBytes, imageByteCount, CLOMetalReleaseDataCallback);
        int bitsPerComponent = 8;
        int bitsPerPixel = 32;
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
        CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
        CGImageRef imageRef = CGImageCreate(imageSize.width,
                                            imageSize.height,
                                            bitsPerComponent,
                                            bitsPerPixel,
                                            bytesPerRow,
                                            colorSpaceRef,
                                            bitmapInfo,
                                            provider,
                                            NULL,
                                            false,
                                            renderingIntent);
        
        image = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:UIImageOrientationDownMirrored];
        
        CFRelease(imageRef);
        CFRelease(colorSpaceRef);
        CFRelease(provider);
    }
    
    return image;
}

+ (UIImage *)CLOxxxxxx:(id<MTLTexture>)texture
{
#if TARGET_IPHONE_SIMULATOR
    SDKAssert;
    return nil;
#else
    NSUInteger width = texture.width;
    NSUInteger height = texture.height;
    
    CVMetalTextureCacheRef textureCache =  NULL;
    CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, texture.device, nil, &textureCache);
    
    NSDictionary *pixelBufferAttributes = @{(__bridge NSString*)kCVPixelBufferIOSurfacePropertiesKey: @{}};
    CVPixelBufferRef pxbuffer = NULL;
    CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, (__bridge CFDictionaryRef)pixelBufferAttributes, &pxbuffer);
    
    CVMetalTextureRef outTexture = NULL;
    CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, pxbuffer, NULL, texture.pixelFormat, width, height, 0, &outTexture);
    
    id<MTLTexture> des = CVMetalTextureGetTexture(outTexture);
    
    // copy
    id<MTLDevice> _device = MTLCreateSystemDefaultDevice();
    id<MTLCommandQueue> queue = _device.newCommandQueue;
    id<MTLCommandBuffer> commandBuffer = queue.commandBuffer;
    id <MTLBlitCommandEncoder> blitEncoder = commandBuffer.blitCommandEncoder;
    
    [blitEncoder copyFromTexture:texture sourceSlice:0 sourceLevel:0 sourceOrigin:MTLOriginMake(0,0,0) sourceSize:MTLSizeMake(width, height, 1)
                       toTexture:des destinationSlice:0 destinationLevel:0 destinationOrigin:MTLOriginMake(0,0,0)];
    [blitEncoder endEncoding];
    [commandBuffer commit];
    
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pxbuffer];
    
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext createCGImage:ciImage fromRect:CGRectMake(0, 0, width, height)];
    
    UIImage *fpsImg = [UIImage imageWithCGImage:videoImage];
    
    
    CFRelease(videoImage);
    CFRelease(outTexture);
    CFRelease(textureCache);
    
    return fpsImg;
    
#endif
}

+ (CVPixelBufferRef)CLOMTLTextureToPixelBuffer:(id<MTLTexture>)texture
{
#if TARGET_IPHONE_SIMULATOR
    SDKAssert;
    return nil;
#else
    id<MTLTexture> unityTexture = texture;
    NSUInteger width = texture.width;
    NSUInteger height = texture.height;
    
    CVMetalTextureCacheRef textureCache =  NULL;
    CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, unityTexture.device, nil, &textureCache);
    
    NSDictionary *pixelBufferAttributes = @{(__bridge NSString*)kCVPixelBufferIOSurfacePropertiesKey: @{}};
    CVPixelBufferRef pxbuffer = NULL;
    CVPixelBufferCreate(kCFAllocatorDefault,
                        width,
                        height,
                        kCVPixelFormatType_32BGRA,
                        (__bridge CFDictionaryRef) pixelBufferAttributes,
                        &pxbuffer);
    
    // 建立绑定
    CVMetalTextureRef outTexture = NULL;
    CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, pxbuffer, NULL, unityTexture.pixelFormat, width, height, 0, &outTexture);
    
    id<MTLTexture> des = CVMetalTextureGetTexture(outTexture);
    
    
    // copy
    id<MTLDevice> _device = MTLCreateSystemDefaultDevice();
    id<MTLCommandQueue> queue = _device.newCommandQueue;
    id<MTLCommandBuffer> commandBuffer = queue.commandBuffer;
    id <MTLBlitCommandEncoder> blitEncoder = commandBuffer.blitCommandEncoder;
    
    [blitEncoder copyFromTexture:unityTexture sourceSlice:0 sourceLevel:0 sourceOrigin:MTLOriginMake(0,0,0) sourceSize:MTLSizeMake(width, height, 1)
                       toTexture:des destinationSlice:0 destinationLevel:0 destinationOrigin:MTLOriginMake(0,0,0)];
    [blitEncoder endEncoding];
    [commandBuffer commit];
    
    
    CFRelease(textureCache);
    CFRelease(outTexture);
    
    return pxbuffer;
#endif
}

+ (unsigned char *)CLOMTLTextureToBytes:(id<MTLTexture>)texture
{
    NSUInteger width = texture.width;
    NSUInteger height = texture.height;
    NSUInteger bytesPerRow = width * 4;
    unsigned char* bytes = malloc(sizeof(unsigned char) * bytesPerRow * height);
    MTLRegion rect = MTLRegionMake2D(0, 0, width, height);
    [texture getBytes:bytes bytesPerRow:bytesPerRow fromRegion:rect mipmapLevel:0];
    
    return bytes;
}

+ (CGImageRef)CLOConvertRGB888ToRGBA8888WithCGImageRef:(CGImageRef)cgImage
{
    @autoreleasepool{
        size_t width = CGImageGetWidth(cgImage);
        size_t height = CGImageGetHeight(cgImage);
        vImage_Buffer srcBuffer, dstBuffer;
        vImage_CGImageFormat srcFormat = {
            (uint32_t)CGImageGetBitsPerComponent(cgImage),
            (uint32_t)CGImageGetBytesPerRow(cgImage),
            CGImageGetColorSpace(cgImage),
            kCGBitmapByteOrderDefault,
            0, NULL,
            kCGRenderingIntentDefault,
        };
        vImage_CGImageFormat dstFormat = {
            8, 32,
            CGColorSpaceCreateDeviceRGB(),
            kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast,
            0, NULL,
            kCGRenderingIntentDefault,
        };
        vImage_Error err = kvImageNoError;
        CGImageRef result = nil;
        
        do {
            err = vImageBuffer_InitWithCGImage(&srcBuffer, &srcFormat, NULL, cgImage, kvImageNoFlags);
            if (err != kvImageNoError) {
                break;
            }
            err = vImageBuffer_Init(&dstBuffer, height, width, 32, kvImageNoFlags);
            if (err != kvImageNoError) {
                break;
            }
            err = vImageConvert_RGB888toRGBA8888(&srcBuffer, NULL, 0xff, &dstBuffer, NO, kvImageNoFlags);
            if (err != kvImageNoError) {
                break;
            }
            
            if (err != kvImageNoError) {
                break;
            }
            
            result = vImageCreateCGImageFromBuffer(&dstBuffer, &dstFormat, NULL, NULL, kvImageNoFlags, &err);
            
        } while(0);
        
        return result ?: nil;
    }
}

+ (CGImageRef)CLORenderCGImageToRGBA8888WithCGImageRef:(CGImageRef)cgImage
{
    @autoreleasepool{
        
        CGColorSpaceRef colorspaceRef = CGColorSpaceCreateDeviceRGB();
        
        size_t width = CGImageGetWidth(cgImage);
        size_t height = CGImageGetHeight(cgImage);
        size_t bytesPerRow = 4 * width;
        
        CGContextRef context = CGBitmapContextCreate(NULL,
                                                     width,
                                                     height,
                                                     8,
                                                     bytesPerRow,
                                                     colorspaceRef,
                                                     kCGBitmapByteOrderDefault|kCGImageAlphaNoneSkipLast);
        
        
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
        CGImageRef result = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        
        return result;
    }
}

+ (unsigned char *)CLOConvertUIImageToBitmapRGBA8:(UIImage *)image withOutPerRow:(size_t *)oBytesPerRow
{
    size_t w = 0,h = 0;
    return [self.class CLOConvertUIImageToBitmapRGBA8:image withOutPerRow:oBytesPerRow withOutWidth:&w withOutHeight:&h];
}

+ (unsigned char *)CLOConvertUIImageToBitmapRGBA8:(UIImage *)image withOutPerRow:(size_t *)oBytesPerRow withOutWidth:(size_t *)oW withOutHeight:(size_t *)oH
{
    CGImageRef imageRef = image.CGImage;
    
    // Create a bitmap context to draw the uiimage into
    CGContextRef context = [self.class CLONewBitmapRGBA8ContextFromImage:imageRef];
    
    if(!context) {
        SDKLog(@"Error：context = null");
        return NULL;
    }
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    *oW = width;
    *oH = height;
    
    CGRect rect = CGRectMake(0, 0, width, height);
    
    // Draw image into the context to get the raw image data
    CGContextDrawImage(context, rect, imageRef);
    
    // Get a pointer to the data
    unsigned char *bitmapData = (unsigned char *)CGBitmapContextGetData(context);
    
    // Copy the data and release the memory (return memory allocated with new)
    size_t bytesPerRow = CGBitmapContextGetBytesPerRow(context);
    *oBytesPerRow = bytesPerRow;
    size_t bufferLength = sizeof(unsigned char) * bytesPerRow * height;
    
    unsigned char *newBitmap = NULL;
    
    if(bitmapData)
    {
        newBitmap = (unsigned char *)malloc(bufferLength);
        memcpy(newBitmap, bitmapData, bufferLength);
    } else {
        SDKLog(@"Error getting bitmap pixel data\n");
    }
    
    CGContextRelease(context);
    
    return newBitmap;
}

+ (CGContextRef)CLONewBitmapRGBA8ContextFromImage:(CGImageRef)image
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    uint32_t *bitmapData;
    
    size_t bitsPerPixel = 32;
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = 4;
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    size_t bytesPerRow = width * bytesPerPixel;
    size_t bufferLength = bytesPerRow * height;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if(!colorSpace) {
        SDKLog(@"Error allocating color space RGB\n");
        return NULL;
    }
    
    // Allocate memory for image data
    bitmapData = (uint32_t *)malloc(sizeof(uint32_t) * bufferLength);
    
    if(!bitmapData) {
        SDKLog(@"Error allocating memory for bitmap\n");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    //Create bitmap context
    context = CGBitmapContextCreateWithData(bitmapData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast, CLOCGBitmapContextReleaseDataCallback, NULL);    // RGBA
    if(!context) {
        
        SDKLog(@"Bitmap context not created");
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

+ (UIImage *)CLOCreateRGBAImage:(unsigned char *)pixelDataX withBytesPerPixel:(NSUInteger)bytesPerPixel width:(NSUInteger)w height:(NSUInteger)h
{
    // bytesPerPixel 支持 1，3，4
    NSUInteger channel = 4;// 通道4
    NSUInteger allCount = channel * w * h;
    
    // copy内存 , 释放被 CLOMetalReleaseDataCallback 接管
    unsigned char *copy = malloc(sizeof(unsigned char) * allCount);
    memset(copy, 0, allCount);
    if (bytesPerPixel == 1)
    {
        for (int i = 0; i < w * h; ++i)
        {
//            copy[i * channel + 0] = 0; // 被 memset 了
//            copy[i * channel + 1] = 0;
//            copy[i * channel + 2] = 0;
            copy[i * channel + 3] = pixelDataX[i];
        }
    }
    else if (bytesPerPixel == 4)
    {
        memcpy(copy, pixelDataX, allCount);
    }
    else {
        SDKAssert;
        free(copy);
        return nil;
    }
    
//    NSUInteger bytesPerRow = w * channel;
//
//    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, copy, h * bytesPerRow, CLOMetalReleaseDataCallback);
//
//    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//
//    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Little;
//    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
//
//    NSUInteger bitsPerComponent = 8;
//    NSUInteger bitsPerPixel = channel * bitsPerComponent;
//
//    CGImageRef imageRef = CGImageCreate(w, h, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
//
//    UIImage *uiImage = [[UIImage alloc] initWithCGImage:imageRef];
//
//    CGImageRelease(imageRef);
//    CGColorSpaceRelease(colorSpaceRef);
//    CGDataProviderRelease(provider);
//
//    return uiImage;
    
    
    NSUInteger bytesPerRow = w * channel;
    CGImageAlphaInfo alphaInfo = kCGImageAlphaPremultipliedLast;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bitsPerComponent = 8;
    
    CGContextRef context = CGBitmapContextCreateWithData(copy, w, h, bitsPerComponent, bytesPerRow, colorSpace, alphaInfo, CLOCGBitmapContextReleaseDataCallback, NULL);
    
    if (context == NULL)
    {
        SDKAssert;
        return nil;
    }
    
    CGImageRef cgImageRef = CGBitmapContextCreateImage(context);
    
    UIImage *grayImage = [[UIImage alloc] initWithCGImage:cgImageRef];
    
    CGImageRelease(cgImageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
//    NSData *iiii = UIImagePNGRepresentation(grayImage);
//    unsigned char *xxx = malloc(allCount);
//    [iiii getBytes:xxx length:allCount];
    
    return grayImage;
}

+ (UIImage *)CLOMergeRGBAImage:(UIImage *)oriImg withMaskImage:(UIImage *)maskImg
{
    NSData *oriData = UIImagePNGRepresentation(oriImg);
    NSData *maskData = UIImagePNGRepresentation(maskImg);

    return [self.class CLOMergeRGBAData:oriData withMaskData:maskData];
}

+ (UIImage *)CLOMergeRGBAData:(NSData *)ori withMaskData:(NSData *)mask
{
    MTKTextureLoader *loader = [[MTKTextureLoader alloc] initWithDevice:MTLCreateSystemDefaultDevice()];
    
    id<MTLTexture> oriTex = [loader newTextureWithData:ori options:nil error:nil];
    id<MTLTexture> maskTex = [loader newTextureWithData:mask options:nil error:nil];
    
    
    if (!oriTex || !maskTex)
    {
        SDKLog(@"Error: oriTex = %@ ; maskTex = %@", oriTex, maskTex);
        return nil;
    }
    
    unsigned char *oriPtr = [self.class CLOMTLTextureToBytes:oriTex];
    if (!oriPtr)
    {
        SDKLog(@"Error: oriPtr = nil");
        return nil;
    }
    unsigned char *maskPtr = [self.class CLOMTLTextureToBytes:maskTex];
    if (!maskPtr)
    {
        SDKLog(@"Error: maskPtr = nil");
        free(oriPtr);
        return nil;
    }
    
    UIImage *img = nil;
    
    size_t channel = 4;
    size_t oriWidth = oriTex.width;
    size_t oriHeight = oriTex.height;

    for (int i = 0; i < oriWidth * oriHeight; ++i) {
        // 按像素遍历 BGRA
        // 交换一下顺序， BGRA => RGBA
        unsigned char tmp = oriPtr[i * channel + 0];
        oriPtr[i * channel + 0] = oriPtr[i * channel + 2];
        oriPtr[i * channel + 2] = tmp;
        
        oriPtr[i * channel + 3] = maskPtr[i * channel + 3];
    }
    
    img = [self.class CLOCreateRGBAImage:oriPtr withBytesPerPixel:channel width:oriWidth height:oriHeight];
    
    free(oriPtr);
    free(maskPtr);
    
    return img;
}
@end
