//
//  CLOSize.m
//  AFNetworking
//
//  Created by Cc on 2019/7/24.
//

#import "CLOSize.h"

@implementation CLOSize

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _width = 0;
        _height = 0;
    }
    return self;
}

- (CGSize)ToCGSize
{
    return CGSizeMake([self.width floatValue], [self.height floatValue]);
}
@end
