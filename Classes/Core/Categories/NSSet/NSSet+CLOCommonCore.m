//
//  NSSet+CLOCommonCore.m
//  CLOCommon
//
//  Created by Cc on 14-10-14.
//

#import "NSSet+CLOCommonCore.h"
#import "CLOLogHelper.h"

@implementation NSSet (CLOCommonCore)

- (id)CLOSearchCommonFirstObjectByKey:(NSString *)key byValue:(NSString *)value
{
    return [[self CLOSearchCommonAllObjectByKey:key byValue:value] firstObject];
}


- (NSArray *)CLOSearchCommonAllObjectByKey:(NSString *)key byValue:(NSString *)value
{
    if ([key isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
        return [self CLOSearchCommonAllObjectByPredicates:@[predicate]];
    }
    else {
        
        SDKErrorLog(@"[key isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]  return NO");
    }
    
    return nil;
}


- (NSArray *)CLOSearchCommonAllObjectByPredicates:(NSArray *)aPredicates
{
    NSPredicate *predicate = nil;
    if (aPredicates && aPredicates.count > 0) {
        
        if (aPredicates.count > 1) {
            
            predicate = [NSCompoundPredicate andPredicateWithSubpredicates:aPredicates];
        }
        else {
            
            predicate = [aPredicates firstObject];
        }
        
        return [[self filteredSetUsingPredicate:predicate] allObjects];
    }
    
    return [self allObjects];
}


- (NSArray*)CLOSortCommonDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending
{
    if ([key isKindOfClass:[NSString class]]) {
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
        
        NSArray *set = [self sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        return set.count > 0 ? set : nil;
    }
    else {
        
        SDKErrorLog(@"[key isKindOfClass:[NSString class]]  return NO");
    }
    
    return nil;
}

@end
