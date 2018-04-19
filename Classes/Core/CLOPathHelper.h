//
//  CLOPathHelper.h
//  CLOAlbum
//
//  Created by Cc on 2018/1/13.
//

#import <Foundation/Foundation.h>

@interface CLOPathHelper : NSObject

/**
 获取app document 路径

 @return 路径
 */
+ (NSString *)sGetDocumentDirectoryPath;

/**
 获取 app library 路径

 @return 路径
 */
+ (NSString *)sGetLibraryDirectoryPath;
@end
