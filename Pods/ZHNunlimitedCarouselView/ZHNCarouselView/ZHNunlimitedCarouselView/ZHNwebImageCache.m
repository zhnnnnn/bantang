//
//  ZHNwebImageCache.m
//  radiousConor
//
//  Created by zhn on 16/4/29.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "ZHNwebImageCache.h"
#import "ZHNdiskCache.h"
#import "ZHNmemoryCache.h"

@interface ZHNwebImageCache()

@property (nonatomic,strong) ZHNdiskCache * disCache;
@property (nonatomic,strong) ZHNmemoryCache * memoryCache;

@end


@implementation ZHNwebImageCache

+ (ZHNwebImageCache *)shareInstance{
    static dispatch_once_t oncet;
    static id webImageCache;
    dispatch_once(&oncet, ^{
        webImageCache = [[ZHNwebImageCache alloc]init];
    });
    
    return webImageCache;
}

- (instancetype)init{
    if (self = [super init]) {
        self.disCache = [[ZHNdiskCache alloc]initWithName:@"defaultWebCache"];
        self.memoryCache = [[ZHNmemoryCache alloc]init];
        self.maxCacheTime = 60 * 60 * 24 * 3; // 图片的最大缓存时间是三天
        // 必要的时候对缓存做处理
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickMemory) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cleankDisk) name:UIApplicationWillTerminateNotification object:nil];
       
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backGroundCleanDisk) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

#pragma mark - 清除缓存
- (void)clickMemory{
    [self.memoryCache ZHNmemoryCache_removeAllImage];
}

- (void)cleankDisk{
    [self backGroundCleanDisk];
}

- (void)backGroundCleanDisk{
    
    // sdwebimage 的清除图片的方法根据设置的过期时间在进入后台的时候去删除一波图片
    
    dispatch_async(self.disCache.setGetImageQueue, ^{
        NSURL *diskCacheURL = [NSURL fileURLWithPath:self.disCache.disCachePath isDirectory:YES];
        NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
        
        // This enumerator prefetches useful properties for our cache files.
        NSDirectoryEnumerator *fileEnumerator = [self.disCache.fileManeger enumeratorAtURL:diskCacheURL
                                                   includingPropertiesForKeys:resourceKeys
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];
        
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-self.maxCacheTime];
        NSMutableDictionary *cacheFiles = [NSMutableDictionary dictionary];
        NSUInteger currentCacheSize = 0;
        
        // Enumerate all of the files in the cache directory.  This loop has two purposes:
        //
        //  1. Removing files that are older than the expiration date.
        //  2. Storing file attributes for the size-based cleanup pass.
        NSMutableArray *urlsToDelete = [[NSMutableArray alloc] init];
        for (NSURL *fileURL in fileEnumerator) {
            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];
            
            // Skip directories.
            if ([resourceValues[NSURLIsDirectoryKey] boolValue]) {
                continue;
            }
            
            // Remove files that are older than the expiration date;
            NSDate *modificationDate = resourceValues[NSURLContentModificationDateKey];
            if ([[modificationDate laterDate:expirationDate] isEqualToDate:expirationDate]) {
                [urlsToDelete addObject:fileURL];
                continue;
            }
            
            // Store a reference to this file and account for its total size.
            NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
            currentCacheSize += [totalAllocatedSize unsignedIntegerValue];
            [cacheFiles setObject:resourceValues forKey:fileURL];
        }
        
        for (NSURL *fileURL in urlsToDelete) {
            [self.disCache.fileManeger removeItemAtURL:fileURL error:nil];
        }
        
        // If our remaining disk cache exceeds a configured maximum size, perform a second
        // size-based cleanup pass.  We delete the oldest files first.
        if (currentCacheSize > self.maxCacheTime) {
            // Target half of our maximum cache size for this cleanup pass.
            const NSUInteger desiredCacheSize = self.maxCacheTime / 2;
            
            // Sort the remaining cache files by their last modification time (oldest first).
            NSArray *sortedFiles = [cacheFiles keysSortedByValueWithOptions:NSSortConcurrent
                                                            usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                                return [obj1[NSURLContentModificationDateKey] compare:obj2[NSURLContentModificationDateKey]];
                                                            }];
            
            // Delete files until we fall below our desired cache size.
            for (NSURL *fileURL in sortedFiles) {
                if ([self.disCache.fileManeger removeItemAtURL:fileURL error:nil]) {
                    NSDictionary *resourceValues = cacheFiles[fileURL];
                    NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
                    currentCacheSize -= [totalAllocatedSize unsignedIntegerValue];
                    
                    if (currentCacheSize < desiredCacheSize) {
                        break;
                    }
                }
            }
        }
    });
}

#pragma mark - 存取方法
- (void)zhnWebImageCache_setImage:(UIImage *)image key:(NSString *)key{

    [self zhnWebImageCache_setImage:image imageData:nil key:key];
}

- (void)zhnWebImageCache_setImage:(UIImage *)image imageData:(NSData *)imageData key:(NSString *)key{
    
    if (![self.memoryCache zhnMemoryCache_getImageWithKey:key]) {
        if (image) {
            [self.memoryCache zhnMemoryCache_setImage:image withKey:key];
        }else if(imageData){
            [self.memoryCache zhnMemoryCache_setImage:[UIImage imageWithData:imageData] withKey:key];
        }
    }
    
    if(![self.disCache zhnDiskCache_getImageWithKey:key]){
        if (imageData) {
            [self.disCache zhnDiskCache_saveImage:nil imageData:imageData key:key];
        }else{
            [self.disCache zhnDiskCache_saveImage:image imageData:nil key:key];
        }
    }
}

- (UIImage *)zhnWebImageCache_getImageWithKey:(NSString *)key{
    
    UIImage * memoryImage = [self.memoryCache zhnMemoryCache_getImageWithKey:key];
    if (memoryImage) {
        return memoryImage;
    }
    else if([self.disCache zhnDiskCache_getImageWithKey:key]){
     
        [self.memoryCache zhnMemoryCache_setImage:[self.disCache zhnDiskCache_getImageWithKey:key] withKey:key];
        
        return [self.disCache zhnDiskCache_getImageWithKey:key];
    }
    else return nil;
}
- (void)zhnWebImageCache_removeImageWithKey:(NSString *)key{
    
    [self.disCache zhnDiskCache_removeImageWithKey:key];
    [self.memoryCache zhnMemoryCache_removeImageWithKey:key];
}
- (void)zhnWebImageCache_clearImages{
    [self.disCache zhnDiskCache_removeAllImages];
    [self.memoryCache ZHNmemoryCache_removeAllImage];
}
@end
