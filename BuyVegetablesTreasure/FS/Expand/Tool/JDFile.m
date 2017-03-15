//
//  JDFile.m
//   
//
//  Copyright © 2016年 Jidu. All rights reserved.
//

#import "JDFile.h"
#import <sys/stat.h>
#import <dirent.h>

@implementation JDFile

+ (BOOL)isFileExist:(NSString *)filePath {
    if (filePath == nil) return false;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

+ (BOOL)createDirectory:(NSString *)filePath {
    if ([JDFile isFileExist:filePath]) {
        return YES;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    
    [fm createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error];
    if (error!=nil) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    return YES;
}

+ (BOOL)renameFile:(NSString *)filePath toFile:(NSString *)toPath {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    if ([JDFile isFileExist:toPath]) {
        [fm removeItemAtPath:filePath error:&error];
        if (error!=nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    [fm moveItemAtPath:filePath toPath:toPath error:&error];
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    return YES;
}

+ (BOOL)deleteFile:(NSString *)filePath {
    if (![JDFile isFileExist:filePath]) {
        return YES;
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    
    [fm removeItemAtPath:filePath error:&error];
    if (error!=nil) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    return YES;
}

+ (BOOL)copyFromPath:(NSString *)fromPath
              toPath:(NSString *)toPath
           isReplace:(BOOL)isReplace
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    
    if ([JDFile isFileExist:toPath] && isReplace) {
        [JDFile deleteFile:toPath];
    }
    
    [fm copyItemAtPath:fromPath toPath:toPath error:&error];
    if (error!=nil) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    return YES;
}

+ (BOOL)copyContentsFromPath:(NSString *)fromPath
                      toPath:(NSString *)toPath
                   isReplace:(BOOL)isReplace
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    
    NSArray *contents = [fm contentsOfDirectoryAtPath:fromPath error:&error];
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    NSString *toFilePath = nil, *fromFilePath = nil;
    for (NSString *path in contents) {
        
        toFilePath = [toPath stringByAppendingPathComponent:path];
        fromFilePath = [fromPath stringByAppendingPathComponent:path];
        
        if ([JDFile isFileExist:toFilePath] && isReplace) {
            [JDFile deleteFile:toFilePath];
        }
        
        [fm copyItemAtPath:fromFilePath toPath:toFilePath error:&error];
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    
    return YES;
}

+ (BOOL)moveFromPath:(NSString *)fromPath
              toPath:(NSString *)toPath
           isReplace:(BOOL)isReplace
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    
    if ([JDFile isFileExist:toPath] && isReplace) {
        [JDFile deleteFile:toPath];
    }
    
    [fm moveItemAtPath:fromPath toPath:toPath error:&error];
    if (error!=nil) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    return YES;
}

+ (BOOL)moveContentsFromPath:(NSString *)fromPath
                      toPath:(NSString *)toPath
                   isReplace:(BOOL)isReplace
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    
    NSArray *contents = [fm contentsOfDirectoryAtPath:fromPath error:&error];
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    NSString *toFilePath = nil, *fromFilePath = nil;
    for (NSString *path in contents) {
        
        toFilePath = [toPath stringByAppendingPathComponent:path];
        fromFilePath = [fromPath stringByAppendingPathComponent:path];
        
        if ([JDFile isFileExist:toFilePath] && isReplace) {
            [JDFile deleteFile:toFilePath];
        }
        
        [fm moveItemAtPath:fromFilePath toPath:toFilePath error:&error];
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    
    return YES;
}

+ (double)calculteFileSzie:(NSString *)filePath
{
    double fSize = 0.0f;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:filePath error:nil];
    
    if (dirContents == nil) {//文件夹为空时,dirContents不为nil但数目count为0,path为文件时,dirContents=nil
        NSDictionary* dirAttr = [fm attributesOfItemAtPath:filePath error: nil]; //path为文件夹时获得的文件夹大小不准确
        fSize += [[dirAttr objectForKey:NSFileSize] floatValue];
    }
    else {
        for (NSString *dirName in dirContents) {
            fSize +=  [JDFile calculteFileSzie:[filePath stringByAppendingPathComponent:dirName]] ;
        }
    }
    
    return fSize;
}

+ (double)calculteFileSizeAtPath:(const char*)folderPath
{
    double folderSize = 0;
    DIR* dir = opendir(folderPath);
    
    if (dir != NULL) {
        struct dirent* child;
        struct stat st;
        NSInteger folderPathLength = 0;
        char childPath[1024] = {0};
        
        while ((child = readdir(dir))!=NULL) {
            // 忽略目录 .
            if (child->d_type == DT_DIR && (child->d_name[0] == '.' && child->d_name[1] == 0)) {
                continue;
            }
            
            // 忽略目录 ..
            if (child->d_type == DT_DIR && (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0))
                continue;
            
            folderPathLength = strlen(folderPath);
            stpcpy(childPath, folderPath);
            
            if (folderPath[folderPathLength-1] != '/'){
                childPath[folderPathLength] = '/';
                folderPathLength++;
            }
            
            stpcpy(childPath+folderPathLength, child->d_name);
            childPath[folderPathLength + child->d_namlen] = 0;
            
            // 递归计算子目录
            if (child->d_type == DT_DIR) {
                folderSize += [JDFile calculteFileSizeAtPath:childPath];
                // 把目录本身所占的空间也加上
                if(lstat(childPath, &st) == 0)
                    folderSize += st.st_size;
            }
            else if (child->d_type == DT_REG || child->d_type == DT_LNK){ // file or link
                if(lstat(childPath, &st) == 0) {
                    folderSize += st.st_size;
                }
            }
        }
        
    }
    
//    closedir(dir);
    return folderSize;
}

+ (double)calculteFileSzieEx:(NSString *)filePath {
    if (![JDFile isFileExist:filePath]) {
        return 0.0f;
    }
    
    return [JDFile calculteFileSizeAtPath:[filePath cStringUsingEncoding:NSUTF8StringEncoding]];
}

+ (void)deleteFiles:(NSArray *)fileNames inPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:path error:nil];
    
    if (dirContents == nil) {//文件夹为空时,dirContents不为nil但数目count为0,path为文件时,dirContents=nil
        if ([fileNames containsObject:[path lastPathComponent]]) {
            [JDFile deleteFile:path];
        }
    }
    else {
        for (NSString *dirName in dirContents) {
            if ([fileNames containsObject:dirName]) {
                [JDFile deleteFile:[path stringByAppendingPathComponent:dirName]];
            }
            else {
                [JDFile deleteFiles:fileNames inPath: [path stringByAppendingPathComponent:dirName]];
            }
        }
    }
}



+ (void)removeDirectoryPath:(NSString *)directoryPath {
    // 获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    if (!isExist || !isDirectory) {
        // 抛异常
        // name:异常名称
        // reason:报错原因
        NSException *excp = [NSException exceptionWithName:@"pathError" reason:@"需要传入文件夹路径，并且路径要存在" userInfo:nil];
        [excp raise];
        
    }
    
    // 获取cache文件夹下所有文件,不包括子路径的子路径
    NSArray *subPaths = [mgr contentsOfDirectoryAtPath:directoryPath error:nil];
    
    for (NSString *subPath in subPaths) {
        // 拼接完成全路径
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        
        // 删除路径
        [mgr removeItemAtPath:filePath error:nil];
    }
    
}

// 自己去计算SDWebImage做的缓存
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger))completion {
    // 获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    if (!isExist || !isDirectory) {
        // 抛异常
        // name:异常名称
        // reason:报错原因
        NSException *excp = [NSException exceptionWithName:@"pathError" reason:@"需要传入文件夹路径，并且路径要存在" userInfo:nil];
        [excp raise];
        
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 获取文件夹下所有的子路径,包含子路径的子路径
        NSArray *subPaths = [mgr subpathsAtPath:directoryPath];
        
        NSInteger totalSize = 0;
        
        for (NSString *subPath in subPaths) {
            // 获取文件全路径
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            
            // 判断隐藏文件
            if ([filePath containsString:@".DS"]) continue;
            
            // 判断是否文件夹
            BOOL isDirectory;
            // 判断文件是否存在,并且判断是否是文件夹
            BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
            if (!isExist || isDirectory) continue;
            
            // 获取文件属性
            // attributesOfItemAtPath:只能获取文件尺寸,获取文件夹不对,
            NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
            
            // 获取文件尺寸
            NSInteger fileSize = (NSInteger)[attr fileSize];
            
            totalSize += fileSize;
        }
        
        // 计算完成回调
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(totalSize);
            }
        });
        
    });
    
}

+ (void)fileSizeAtPath:(NSString *)filePath completion:(void(^)(NSInteger))completion {
    
    if (![JDFile isFileExist:filePath]) {
        NSException *excp = [NSException exceptionWithName:@"pathError" reason:@"路径不存在" userInfo:nil];
        [excp raise];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSInteger totalSize = [JDFile calculteFileSizeAtPath:[filePath cStringUsingEncoding:NSUTF8StringEncoding]];
        dispatch_async(dispatch_get_main_queue(), ^{

            if (completion) {
                completion(totalSize);
            }
        });
    });
}





#pragma mark - 文件信息获取

/**
 *  获取绝对路径
 *
 *  @param relpath 相对路径
 *  @param type    目录类型(Document/Caches)
 *
 *  @return 绝对路径
 */
//+ (NSString *)getFilepath:(NSString *)relpath pathtype:(PathType)type
//{
//    if (relpath == nil || [relpath length] == 0)
//        return nil;
//    switch (type) {
//        case EDocuments:
//            return DOCUMENTS_PATH(relpath);
//        case ECaches:
//            return CACHES_PATH(relpath);
//    }
//    return nil;
//}



#pragma mark - 文件操作




/**
 *  移动文件
 *
 *  @param from 原始位置
 *  @param to   目标位置
 */
+ (void)moveFile:(NSString *)from to:(NSString *)to
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    [fileManager moveItemAtPath:from toPath:to error:nil];
}



@end
