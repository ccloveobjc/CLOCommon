//
//  UIImage+CLOMetal.m
//  CLOCommon
//
//  Created by Cc on 2019/7/30.
//

#import "UIImage+CLOMetal.h"
#import <Metal/Metal.h>
#import <CLOCommon/CLOCommonCore.h>
#import <CoreVideo/CoreVideo.h>
#import <MetalKit/MetalKit.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (CLOMetal)

static void CLOMetalReleaseDataCallback(void *info, const void *data, size_t size)
{
    free((void *)data);
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
}

+ (CVPixelBufferRef)CLOMTLTextureToPixelBuffer:(id<MTLTexture>)texture
{
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

@end
