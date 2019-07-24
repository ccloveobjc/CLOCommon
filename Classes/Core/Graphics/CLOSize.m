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
        
        CGSizeMake(1, 1);
    }
    return self;
}

- (CGSize)ToCGSize
{
    return CGSizeMake([self.width floatValue], [self.height floatValue]);
}
@end
