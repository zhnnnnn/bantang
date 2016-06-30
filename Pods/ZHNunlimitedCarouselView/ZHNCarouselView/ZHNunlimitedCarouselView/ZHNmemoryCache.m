//
//  ZHNmemoryCache.m
//  radiousConor
//
//  Created by zhn on 16/4/29.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "ZHNmemoryCache.h"


@interface ZHNmemoryCache()
@property (nonatomic,strong) NSCache * memoryCache;
@end


@implementation ZHNmemoryCache
- (instancetype)init{
    if (self = [super init]) {
        _memoryCache = [[NSCache alloc]init];
        _memoryCache.name = @"tempWebCache";
        _memoryCache.countLimit = 100;
        _memoryCache.totalCostLimit = 1024 * 1024 * 50;
    }
    return self;
}

- (void)zhnMemoryCache_setImage:(UIImage *)image withKey:(NSString *)key{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
         [self.memoryCache setObject:image forKey:key];
    });
}
- (UIImage *)zhnMemoryCache_getImageWithKey:(NSString *)key{
    return [self.memoryCache objectForKey:key];
}
- (BOOL)zhnMemoryCache_containsImageWithKey:(NSString *)key{
    return [self.memoryCache objectForKey:key];
}
- (void)zhnMemoryCache_removeImageWithKey:(NSString *)key{
    [self.memoryCache removeObjectForKey:key];
}
- (void)ZHNmemoryCache_removeAllImage{
    [self.memoryCache removeAllObjects];
}

@end
