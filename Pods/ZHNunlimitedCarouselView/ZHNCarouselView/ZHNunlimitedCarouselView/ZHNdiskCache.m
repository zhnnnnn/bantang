//
//  ZHNdiskMemory.m
//  radiousConor
//
//  Created by zhn on 16/4/29.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "ZHNdiskCache.h"

@interface ZHNdiskCache()

@end


@implementation ZHNdiskCache
- (instancetype)initWithName:(NSString *)name{
    if (self = [super init]) {
        NSString * fullName = [@"zhn.image.discache." stringByAppendingString:name];
        self.disCachePath = [self makeDiskCachePath:fullName];
        self.setGetImageQueue = dispatch_queue_create("zhn.image.disCache", DISPATCH_QUEUE_SERIAL);
        self.fileManeger = [NSFileManager defaultManager];
        if (![self.fileManeger fileExistsAtPath:self.disCachePath]) {
            [self.fileManeger createDirectoryAtPath:self.disCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    }
    return self;
}
- (NSString *)zhnImage_getFullNameWithKey:(NSString *)key{
    return [self.disCachePath stringByAppendingString:key];
}
- (NSString *)makeDiskCachePath:(NSString*)fullNamespace{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:fullNamespace];
}

- (void)zhnDiskCache_saveImage:(UIImage *)image imageData:(NSData *)downLoadImageData key:(NSString *)key{
    NSData * imageData;
    if (image) {
       imageData = UIImageJPEGRepresentation(image, 1.0);
    }else{
        imageData = downLoadImageData;
    }
    dispatch_async(self.setGetImageQueue, ^{
        
        if (imageData) {
            NSString * imageFile = [self.disCachePath stringByAppendingPathComponent:key];
            if (![self.fileManeger fileExistsAtPath:imageFile]) {
                [self.fileManeger createFileAtPath:imageFile contents:imageData attributes:nil];
            }
        }
    });
}

- (void)zhnDiskCache_GetImageWithBlock:(getImageBlock)block key:(NSString *)key{
    
    NSString * filePath = [self.disCachePath stringByAppendingPathComponent:key];
    __block UIImage * cacheimage;
    dispatch_async(self.setGetImageQueue, ^{
        NSData * imageData = [NSData dataWithContentsOfFile:filePath];
        cacheimage = [UIImage imageWithData:imageData];
        block(cacheimage);
    });
}


- (UIImage *)zhnDiskCache_getImageWithKey:(NSString *)key{

    NSString * filePath = [self.disCachePath stringByAppendingPathComponent:key];    
    UIImage * cacheimage;
    NSData * imageData = [NSData dataWithContentsOfFile:filePath];
    cacheimage = [UIImage imageWithData:imageData];
    
    return  cacheimage;
}

- (BOOL)zhnDiskCache_ContainsImageWithKey:(NSString *)key{
    return [self zhnDiskCache_getImageWithKey:key];
}
- (void)zhnDiskCache_removeImageWithKey:(NSString *)key{
    NSString * filePath = [self.disCachePath stringByAppendingString:key];
    dispatch_async(self.setGetImageQueue, ^{
        [self.fileManeger removeItemAtPath:filePath error:nil];
    });
}
- (void)zhnDiskCache_removeAllImages{
    dispatch_async(self.setGetImageQueue, ^{
        [self.fileManeger removeItemAtPath:self.disCachePath error:nil];
    });
}




@end
