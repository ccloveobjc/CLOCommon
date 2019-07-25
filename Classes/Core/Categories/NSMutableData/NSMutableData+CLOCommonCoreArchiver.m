//
//  NSMutableData+CLOCommonCoreArchiver.m
//  CLOCommon
//
//  Created by Cc on 16/4/7.
//

#import "NSMutableData+CLOCommonCoreArchiver.h"
#import "CLOLogHelper.h"

@implementation NSMutableData (CLOCommonCoreArchiver)

+ (instancetype)CLOArchiver:(id<NSCoding>)obj
{
    if (obj) {
        
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeRootObject:obj];
        [archiver finishEncoding];
        return data;
    }
    SDKAssertElseLog(@"不能为空")
    
    return nil;
}

+ (id)CLOUnarchiver:(NSData *)data
{
    if (data) {
        
        NSData *oData = data;
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:oData];
        id vData = [unarchiver decodeObject];
        return vData;
    }
    SDKAssertElseLog(@"不能为空")
    
    return nil;
}

@end
