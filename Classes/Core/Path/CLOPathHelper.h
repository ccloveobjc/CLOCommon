//
//  CLOPathHelper.h
//  CLOCommon
//
//  Created by Cc on 2018/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLOPathHelper : NSObject

/**
 获取app document 路径

 @return 路径
 */
+ (NSString *)getDocumentDirectoryPath;

/**
 获取 app library 路径

 @return 路径
 */
+ (NSString *)getLibraryDirectoryPath;
@end

NS_ASSUME_NONNULL_END
