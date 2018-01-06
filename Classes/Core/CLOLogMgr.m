//
//  CLOLogMgr.m
//  CLOAlbum
//
//  Created by Cc on 2018/1/6.
//

#import "CLOLogMgr.h"

@implementation CLOLogMgr
+ (instancetype)sInstance
{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
    });
    
    return _instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)dealloc
{
    
}
@end
