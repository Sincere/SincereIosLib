//
//  FcFileUtil.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/11/27.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScFileUtil.h"

@implementation ScFileUtil

+ (BOOL)createDirectoryIfNeed:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *dir = [path stringByDeletingLastPathComponent];
    if(![fm fileExistsAtPath:dir])
    {
        return [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    
    BOOL __unused res = [[NSFileManager defaultManager] fileExistsAtPath: [URL path]];
    NSAssert1(res, @"%@ is not exists.", URL);
    
    if(SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"5.0.1"))
    {
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return (result == 0);
    }
    else
    {
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        
        NSAssert2(success, @"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        
        return success;
    }
}

+ (NSInteger)sizeOfPath:(NSString *)path
{
    NSInteger result = 0;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    BOOL isDir;
    [fm fileExistsAtPath:path isDirectory:&isDir];
    if(isDir)
    {
        for (NSString *child in [fm contentsOfDirectoryAtPath:path error:nil])
        {
            result += [self sizeOfPath:[path stringByAppendingPathComponent:child]];
        }
    }
    else
    {
        result = [[[fm attributesOfItemAtPath:path error:nil] objectForKey:NSFileSize] integerValue];
    }
    
    return result;
}

@end
