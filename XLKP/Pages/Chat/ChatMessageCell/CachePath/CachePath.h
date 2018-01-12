//
//  CachePath.h
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CachePath : NSObject


/**
 * 获取Document文件路径

 @param fileName fileName description
 @return return value description
 */
+ (NSString *)getFileDocumentPath:(NSString *)fileName;


/**
 * 获取Cache文件路径

 @param fileName fileName description
 @return return value description
 */
+ (NSString *)getFileCachePath:(NSString *)fileName;


/**
 *获取资源文件的路径

 @param fileName fileName description
 @return return value description
 */
+ (NSString *)getFileResourcePath:(NSString *)fileName;


/**
 *将资源文件拷贝到文档目录下

 @param resourceName resourceName description
 @return return value description
 */
+ (BOOL)copyResourceFileToDocumentPath:(NSString *)resourceName;


/**
 * 判断一个文件是否存在于document目录下

 @param fileName fileName description
 @return return value description
 */
+ (BOOL)isExistFileInDocument:(NSString *)fileName;


/**
 * 判断一个文件是否存在于cache目录下

 @param fileName fileName description
 @return return value description
 */
+ (BOOL)isExistFileInCache:(NSString *)fileName;


/**
 * 删除Documet目录下的一个文件夹

 @param aFolderNameInDoc aFolderNameInDoc description
 @return return value description
 */
+ (BOOL)removeFolderInDocumet:(NSString *)aFolderNameInDoc;


/**
 * 删除cache目录下的一个文件夹

 @param aFolderNameInCahe aFolderNameInCahe description
 @return return value description
 */
+ (BOOL)removeFolderInCahe:(NSString *)aFolderNameInCahe;


/**
 * 判断一个文件是否存在于resource目录下

 @param fileName fileName description
 @return return value description
 */
+ (BOOL)isExistFileInResource:(NSString *)fileName;


/**
 *  判断一个全路径文件是否存在

 @param aFilePath aFilePath description
 @return return value description
 */
+ (BOOL)isExistFile:(NSString *)aFilePath;


/**
 * 删除文件

 @param filePath filePath description
 @return return value description
 */
+ (BOOL)deleteFileAtPath:(NSString *)filePath;


/**
 * 获取文件的属性集合

 @param filePath filePath description
 @return return value description
 */
+ (NSDictionary *)getFileAttributsAtPath:(NSString *)filePath;


/**
 *在document目录下创建一个目录

 @param dirName dirName description
 @return return value description
 */
+ (BOOL)createDirectoryAtDocument:(NSString *)dirName;


/**
 *在Cache目录下创建一个目录

 @param dirName dirName description
 @return return value description
 */
+ (BOOL)createDirectoryAtCache:(NSString *)dirName;



/**
 *在Temporary目录下创建一个目录

 @param dirName dirName description
 @return return value description
 */
+ (BOOL)createDirectoryAtTemporary:(NSString *)dirName;


/**
 * 获取文档目录路径

 @return return value description
 
 */
+ (NSString *)getDocumentPath;


/**
 *获取cache目录路径

 @return return value description
 */
+ (NSString *)getCachePath;


/**
 *获取Temporary目录路径

 @return return value description
 */
+ (NSString *)getTemporaryPath;

/**
 *计算文件夹大小

 @return return value description
 */
+ (long long)getFreeSpaceOfDisk;


/**
 * 在iOS5 .1及以上防止文件被被备份到iCloud和iTunes上

 @param URL URL description
 @return return value description
 */
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;


/**
 * 图片缓存路径

 @return return value description
 */
+ (NSString *)imageCachePath;
@end
