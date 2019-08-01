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

@implementation UIImage (CLOMetal)

static void CLOMetalReleaseDataCallback(void *info, const void *data, size_t size)
{
    free((void *)data);
}

+ (UIImage *)CLOImageWithMTLTexture:(id<MTLTexture>)texture
{
//    SDKAssert([texture pixelFormat] == MTLPixelFormatBGRA8Unorm, @"Pixel format of texture must be MTLPixelFormatBGRA8Unorm to create UIImage");
    
    CGSize imageSize = CGSizeMake([texture width], [texture height]);
    size_t imageByteCount = imageSize.width * imageSize.height * 4;
    void *imageBytes = malloc(imageByteCount);
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
    
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:UIImageOrientationDownMirrored];
    
    CFRelease(provider);
    CFRelease(colorSpaceRef);
    CFRelease(imageRef);
    
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

+ (CVPixelBufferRef)CLOxx:(id<MTLTexture>)texture
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
@end
