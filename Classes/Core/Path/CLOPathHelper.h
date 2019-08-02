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

+ (BOOL)CLOAddSkipBackupAttributeToItemAtFilePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
