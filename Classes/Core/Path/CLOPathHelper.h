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
+ (NSString *)CLOGotDocumentDirectoryPath;

/**
 获取 app library 路径

 @return 路径
 */
+ (NSString *)CLOGotLibraryDirectoryPath;

+ (BOOL)CLOFileExists:(NSString *)filenamePath;

+ (BOOL)CLOFileExistsURL:(NSURL *)filenamePath;

+ (BOOL)CLOCreateFile:(NSData *)data andPath:(NSString *)path;

+ (BOOL)CLORemoveFile:(NSString *)filePath;

+ (BOOL)CLODirectoryExists:(NSString *)dirPath;

+ (BOOL)CLODirectoryExistsURL:(NSURL *)dirUrl;

+ (BOOL)CLOCreateDirectory:(NSString *)dirPath;

+ (BOOL)CLOCreateDirectoryURL:(NSURL *)dirUrl;

+ (BOOL)CLORemoveDirectory:(NSString *)dirPath;

+ (BOOL)CLORemoveDirectoryURL:(NSURL *)dirPath;

+ (BOOL)CLOCopyFile:(NSString *)from To:(NSString *)to;

+ (BOOL)CLOCopyImageFile:(NSString *)from To:(NSString *)to;

+ (BOOL)CLOCopyItemURL:(NSURL *)from To:(NSURL *)to;

/**
 copy 一个文件夹到另一个文件夹
 */
+ (BOOL)CLOCopyDirectory:(NSString *)from To:(NSString *)to;

/**
 创建文件的前置目录
 比如 /xxx/yyy/jjj.png 就创建 /xxx/yyy 文件夹
 */
+ (BOOL)CLOCreateFileDirectory:(NSString *)filePath;
+ (BOOL)CLOCreateFileDirectoryURL:(NSURL *)filePath;

+ (BOOL)CLOAddSkipBackupAttributeToItemAtFilePath:(NSString *)filePath;

/**
 获取文件夹内所有文件的物理大小
 */
+ (NSUInteger)getDirectoryLength:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
