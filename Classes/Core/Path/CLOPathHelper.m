//
//  CLOPathHelper.m
//  CLOCommon
//
//  Created by Cc on 2018/1/13.
//

#import "CLOPathHelper.h"
#import "CLOLogHelper.h"

@implementation CLOPathHelper

+ (NSString *)CLOGotDocumentDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)CLOGotLibraryDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

+ (BOOL)CLOFileExists:(NSString *)filenamePath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filenamePath];
}

+ (BOOL)CLOFileExistsURL:(NSURL *)filenamePath
{
    return [filenamePath checkResourceIsReachableAndReturnError:nil];
}


+ (BOOL)CLOCreateFile:(NSData *)data andPath:(NSString *)path
{
    return [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
}


+ (BOOL)CLORemoveFile:(NSString *)filePath
{
    if ([self CLOFileExists:filePath]) {
        
        return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    
    return YES;
}


+ (BOOL)CLODirectoryExists:(NSString *)dirPath
{
    BOOL bo = YES;
    return [[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&bo];
}
+ (BOOL)CLODirectoryExistsURL:(NSURL *)dirUrl
{
    return [self CLOFileExistsURL:dirUrl];
}


+ (BOOL)CLOCreateDirectory:(NSString *)dirPath
{
    if (![self CLODirectoryExists:dirPath])
    {
        NSError *error = nil;
        BOOL bRet = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath
                                              withIntermediateDirectories:YES
                                                               attributes:nil
                                                                    error:&error];
        if (error) {
            
            SDKErrorLog(@"Error: sCreateDirectory %@",error);
        }
        
        return bRet;
    }
    
    return YES;
}
+ (BOOL)CLOCreateDirectoryURL:(NSURL *)dirUrl
{
    if (![self CLODirectoryExistsURL:dirUrl]) {
        
        NSError *error = nil;
        BOOL bRet = [[NSFileManager defaultManager] createDirectoryAtURL:dirUrl
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:&error];
        if (!bRet) {
            
            SDKErrorLog(@"Error: sCreateDirectoryURL %@",error);
        }
        
        return bRet;
    }
    
    return YES;
}


+ (BOOL)CLORemoveDirectory:(NSString *)dirPath
{
    NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager] enumeratorAtPath:dirPath];
    if (direnum) {
        
        NSString *fileName;
        while ((fileName = [direnum nextObject])) {
            
            [self CLORemoveFile:[dirPath stringByAppendingFormat:@"/%@", fileName]];
        }
        
        return [[NSFileManager defaultManager] removeItemAtPath:dirPath error:nil];
    }
    
    return YES;
}
+ (BOOL)CLORemoveDirectoryURL:(NSURL *)dirPath
{
    BOOL bRet = NO;
    NSError *error = nil;
    bRet = [[NSFileManager defaultManager] removeItemAtURL:dirPath error:&error];
    if (!bRet) {
        
        SDKErrorLog(@"sRemoveDirectoryURL error = %@", error);
    }
    else {
        
        SDKLog(@"删除目录 url = %@", dirPath);
    }
    
    return bRet;
}

+ (BOOL)CLOCopyFile:(NSString *)from To:(NSString *)to
{
    if ([self CLOFileExists:from]) {
        
        if ([self CLOFileExists:to]) {
            
            [self CLORemoveFile:to];
        }
        
        [CLOPathHelper CLOCreateFileDirectory:to];
        
        NSError *error = nil;
        [[NSFileManager defaultManager] copyItemAtPath:from toPath:to error:&error];
        if (error) {
            
            SDKErrorLog(@"Error:%@", [error userInfo]);
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}

+ (BOOL)CLOCopyImageFile:(NSString *)from To:(NSString *)to
{
    if ([self CLOFileExists:from]) {
        
        if ([self CLOFileExists:to]) {
            
            [self CLORemoveFile:to];
        }
        
        [CLOPathHelper CLOCreateFileDirectory:to];
        
        char const *path_cstr = [[NSFileManager defaultManager] fileSystemRepresentationWithPath:from];
        FILE *fh = fopen(path_cstr, "r");
        if (fh != NULL) {
            
            unsigned char word;
            fread(&word, 1, 1, fh);
            fclose(fh);
            if (word == 0xFF) { //jpg
                
                NSError *error = nil;
                [[NSFileManager defaultManager] copyItemAtPath:from toPath:to error:&error];
                if (error) {
                    
                    SDKErrorLog(@"Error:%@", [error userInfo]);
                    return NO;
                }
                
                return YES;
            }
            else if (word == 0x89) {    //png
                
                UIImage *image = [[UIImage alloc] initWithContentsOfFile:from];
                if (image) {
                    
                    [UIImageJPEGRepresentation(image, 1.0) writeToFile:to atomically:YES];
                    return YES;
                }
            }
        }
        else {
            
            SDKErrorLog(@"fopen 失败");
        }
    }
    
    return NO;
}

+ (BOOL)CLOCopyItemURL:(NSURL *)from To:(NSURL *)to
{
    BOOL bRet = NO;
    if ([self CLOFileExistsURL:from]) {
        
        if ([self CLOFileExistsURL:to]) {
            
            [self CLORemoveDirectoryURL:to];
        }
        
        [CLOPathHelper CLOCreateFileDirectoryURL:to];
        
        NSError *error = nil;
        bRet = [[NSFileManager defaultManager] copyItemAtURL:from toURL:to error:&error];
        if (error) {
            
            SDKErrorLog(@"%@ ;;;;;;; %@", error, [error userInfo]);
        }
    }
    
    return bRet;
}

+ (BOOL)CLOCopyDirectory:(NSString *)from To:(NSString *)to
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray* array = [fileManager contentsOfDirectoryAtPath:from error:nil];
    for(int i = 0; i < [array count]; i++)
    {
        NSString *fullPath = [from stringByAppendingPathComponent:[array objectAtIndex:i]];
        NSString *fullToPath = [to stringByAppendingPathComponent:[array objectAtIndex:i]];

        //判断是不是文件夹
        BOOL isFolder = NO;

        //判断是不是存在路径 并且是不是文件夹
        BOOL isExist = [fileManager fileExistsAtPath:fullPath isDirectory:&isFolder];
        if (isExist)
        {
            if (isFolder)
            {
                if (![self CLOCopyDirectory:fullPath To:fullToPath]) {
                    
                    return NO;
                }
            }
            else
            {
                BOOL ret = [CLOPathHelper CLOCopyFile:fullPath To:fullToPath];
                if (ret == NO) {
                    // 当错误时，返回
                    return ret;
                }
            }
        }
    }
    
    return YES;
}

+ (BOOL)CLOCreateFileDirectory:(NSString *)filePath
{
    NSString *dir = [filePath stringByDeletingLastPathComponent];
    return [CLOPathHelper CLOCreateDirectory:dir];
}

+ (BOOL)CLOCreateFileDirectoryURL:(NSURL *)filePath
{
    NSURL *dir = [filePath URLByDeletingLastPathComponent];
    return [CLOPathHelper CLOCreateDirectoryURL:dir];
}


+ (NSUInteger)getDirectoryLength:(NSString *)path
{
    // 总大小
    NSUInteger size = 0;
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    BOOL exist = [manager fileExistsAtPath:path isDirectory:&isDir];
    
    // 判断路径是否存在
    if (!exist) return size;
    if (isDir) {
        // 是文件夹
        NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:path];
        for (NSString *subPath in enumerator) {
        
            NSString *fullPath = [path stringByAppendingPathComponent:subPath];
            size += [CLOPathHelper getDirectoryLength:fullPath];
        }
    }
    else { // 是文件
        
        size += [manager attributesOfItemAtPath:path error:nil].fileSize;
    }
    
    return size;
}

#pragma mark - 屏蔽路径
+ (BOOL)CLOAddSkipBackupAttributeToItemAtFilePath:(NSString *)filePath
{
    if (filePath == nil ||  filePath.length == 0) {
        
        SDKAssert;
        return NO;
    }
    NSURL *URL;
    if ([filePath hasPrefix:@"file://"]) {
        
        URL = [NSURL URLWithString:filePath];
    }
    else {
        
        URL = [NSURL fileURLWithPath:filePath];
    }
    
    const BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[URL path]];
    if (isExist) {
        
        NSError *error = nil;
        BOOL success = [URL setResourceValue:@YES
                                      forKey:NSURLIsExcludedFromBackupKey
                                       error:&error];
        if (error) {
            
            SDKErrorLog(@"error_happened %@", error);
        }
        
        return success;
    }
    else {
        
        SDKAssert;
        return NO;
    }
}
@end
