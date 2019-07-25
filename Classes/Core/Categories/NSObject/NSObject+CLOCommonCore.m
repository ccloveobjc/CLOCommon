//
//  NSObject+CLOCommonCore.m
//  CLOCommon
//
//  Created by Cc on 2019/7/25.
//

#import "NSObject+CLOCommonCore.h"
#import <objc/runtime.h>
#import "CLOLogHelper.h"

#define kNanToZero(x) (isnan(x) ? 0 : (x))

static BOOL bEnablePropertyForKey = NO;

@implementation NSObject (CLOCommonCore)

- (id)CLOConvertToClass:(Class)oClass
{
    if ([self isKindOfClass:oClass]) {
        
        return self;
    }
    
    return nil;
}

+ (void)CLOEnablePropertyForKey:(BOOL)bEnable
{
    bEnablePropertyForKey = bEnable;
}

- (BOOL)CLOPropertyForKey:(NSString *)key
{
    if ([key isKindOfClass:[NSString class]]) {
        
        if (bEnablePropertyForKey) {
            
            return [self propertyForKey:key inClass:[self class]];
        }
        
        return YES;
    }
    else {
        
        SDKErrorLog(@"key != NSString");
    }
    
    return NO;
}

- (BOOL)propertyForKey:(NSString *)key inClass:(Class)classType
{
    Class superClass = class_getSuperclass(classType);
    if (superClass != nil && ![superClass isEqual:[NSObject class]]) {
        
        if ([self propertyForKey:key inClass:superClass]) {
            
            return YES;
        }
    }
    
    BOOL bRet = NO;
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([classType class], &outCount);
    for (int i = 0; i < outCount; ++i) {
        
        objc_property_t property = properties[i];
        NSString *strPropertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                             encoding:NSUTF8StringEncoding];
        if ([key isEqualToString:strPropertyName]) {
            
            bRet = YES;
            break;
        }
    }
    free(properties);
    
    return bRet;
}

+ (CGRect)CLOConvertCGRectNaN:(CGRect)rect
{
    if (isnan(rect.origin.x)
        || isnan(rect.origin.y)
        || isnan(rect.size.width)
        || isnan(rect.size.height)) {
        
        return CGRectMake(kNanToZero(rect.origin.x)
                          , kNanToZero(rect.origin.y)
                          , kNanToZero(rect.size.width)
                          , kNanToZero(rect.size.height));
    }
    
    return rect;
}


- (NSArray<NSString *> *)CLOGotPropertiesNameOnThisClass
{
    NSMutableSet<NSString *> *mSet = [NSMutableSet set];
    
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; ++i) {
        
        objc_property_t property = properties[i];
        NSString *strPropertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                             encoding:NSUTF8StringEncoding];
        
        [mSet addObject:strPropertyName];
    }
    free(properties);
    
    return mSet.allObjects;
}

@end
