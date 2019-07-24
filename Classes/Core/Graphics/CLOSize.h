//
//  CLOSize.h
//  AFNetworking
//
//  Created by Cc on 2019/7/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLOSize : NSObject

@property (nonatomic) NSNumber *width;
@property (nonatomic) NSNumber *height;

- (CGSize)ToCGSize;

@end

CG_INLINE CLOSize*
CLOSizeMake(NSNumber *width, NSNumber *height)
{
    CLOSize *size = [CLOSize new]; size.width = width; size.height = height; return size; return size;
}

NS_ASSUME_NONNULL_END
