//
//  NSDictionary+CLOCommonCore.h
//  CLOCommon
//
//  Created by Cc on 2019/7/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (CLOCommonCore)

- (instancetype)CLOGotValueForKey:(id)key withClass:(Class)cls;

- (NSString *)CLOGotStringForKey:(id)key;

- (NSArray *)CLOGotArrayForKey:(id)key;

- (NSNumber *)CLOGotNumberForKey:(id)key;

- (instancetype)CLOGotDictionaryForKey:(nonnull id)key;

- (NSURL *)CLOGotURLForKey:(id)key;

- (BOOL)CLOGotBOOLForKey:(id)key;


- (void)CLOSetupValue:(id)value withKey:(id)key withClass:(Class)cls;

- (void)CLOSetupString:(NSString *)value withKey:(id)key;

- (void)CLOSetupURL:(NSURL *)value withKey:(id)key;

- (void)CLOSetupNumber:(NSNumber *)value withKey:(id)key;

- (void)CLOSetupBOOL:(BOOL)value withKey:(id)key;

@end

NS_ASSUME_NONNULL_END
