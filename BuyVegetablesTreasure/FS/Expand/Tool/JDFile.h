//
//  JDFile.h
//   
//
//  文件操作接口
//
//  Copyright © 2016年 Jidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDFile : NSObject


/**
 *  判断文件或文件夹是否已存在
 *
 *  @param filePath 文件或文件夹的绝对路径
 */
+ (BOOL)isFileExist:(NSString *)filePath;

/**
 *  创建目录
 *
 *  @param filePath 文件或文件夹的绝对路径；不存在才创建
 *
 *  @return 创建成功与否
 */
+ (BOOL)createDirectory:(NSString *)filePath;


/**
 *  重命名文件
 */
+ (BOOL)renameFile:(NSString *)filePath toFile:(NSString *)toPath;

/**
 *  删除文件或文件夹
 *
 *  @param filePath 文件或文件夹的全路径
 */
+ (BOOL)deleteFile:(NSString *)filePath;

/**
 *功能: 将文件或文件夹从一个目录拷贝到另一个目录
 *参数:
 fromPath   : 原始目录,如/Library/11
 toPath     : 目标目录,如/Documents/11
 isReplace  : 如果已经存在,是否替换
 *返回:
 TRUE : 成功
 FALSE: 失败
 **/
+ (BOOL)copyFromPath:(NSString *)fromPath
              toPath:(NSString *)toPath
           isReplace:(BOOL)isReplace;

/**
 *功能: 将文件夹中的内容拷贝到另一个目录中,
 *参数:
 fromPath   : 原始目录,如/Library/11,其中有1.jpg
 toPath     : 目标目录,如/Documents/,执行成功后,/Documents/1.jpg
 isReplace  : 如果已经存在,是否替换
 *返回:
 TRUE : 成功
 FALSE: 失败
 **/
+ (BOOL)copyContentsFromPath:(NSString *)fromPath
                      toPath:(NSString *)toPath
                   isReplace:(BOOL)isReplace;


/**
 *功能: 将文件或文件夹从一个目录移动到另一个目录
 *参数:
 fromPath   : 原始目录,如/Library/11
 toPath     : 目标目录,如/Documents/11
 isReplace  : 如果已经存在,是否替换
 *返回:
 TRUE : 成功
 FALSE: 失败
 **/
+ (BOOL)moveFromPath:(NSString *)fromPath
              toPath:(NSString *)toPath
           isReplace:(BOOL)isReplace;

/**
 *功能: 将文件夹中的内容移动到另一个目录中,
 *参数:
 fromPath   : 原始目录,如/Library/11,其中有1.jpg
 toPath     : 目标目录,如/Documents/,执行成功后,/Documents/1.jpg
 isReplace  : 如果已经存在,是否替换
 *返回:
 TRUE : 成功
 FALSE: 失败
 **/
+ (BOOL)moveContentsFromPath:(NSString *)fromPath
                      toPath:(NSString *)toPath
                   isReplace:(BOOL)isReplace;

/**
 *功能: 计算一个文件或文件夹大小,
 *参数:
 filePath   : 文件或文件夹路径
 *返回: 文件或文件夹所占字节数
 **/
+ (double)calculteFileSzie:(NSString *)filePath;

/**
 *功能: 计算一个文件夹大小,该方法效率更高
 *参数:
 filePath   : 文件或文件夹路径
 *返回: 文件或文件夹所占字节数
 **/
+ (double)calculteFileSzieEx:(NSString *)filePath;


/**
 *功能：递归删除某个目录下的指定文件
 **/
+ (void)deleteFiles:(NSArray *)fileNames inPath:(NSString *)path;


/**
 *  获取文件夹尺寸
 *
 *  @param directoryPath 文件夹路径
 *
 *  @return 返回文件夹尺寸
 */
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger))completion;


/**
 *  删除文件夹所有文件
 *
 *  @param directoryPath 文件夹路径
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath;

+ (void)fileSizeAtPath:(NSString *)filePath completion:(void(^)(NSInteger))completion;

@end
