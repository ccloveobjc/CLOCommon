//
//  NSFileManager+CLOCommonCoreicloud.h
//  CLOCommon
//  
//  Created by Cc on 14-12-3.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  把文件从iCloud上传中屏蔽
*  REV @gs PGLib FileManager
 */
@interface NSFileManager (CLOCommonCoreicloud)

/**
 *  把文件从iCloud中屏蔽
 *
 *  @param filePath 文件路径
 *
 *  @return 是否成功
 */
- (BOOL)CLOAddSkipBackupAttributeToItemAtFilePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
