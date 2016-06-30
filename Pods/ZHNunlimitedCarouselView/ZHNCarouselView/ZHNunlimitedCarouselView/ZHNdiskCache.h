//
//  ZHNdiskMemory.h
//  radiousConor
//
//  Created by zhn on 16/4/29.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^getImageBlock)(UIImage *);

@interface ZHNdiskCache : NSObject
- (instancetype)initWithName:(NSString *)name;
/**
 *  存储图片到cache
 *
 *  @param image 图片
 *  @param key   键值
 */
- (void)zhnDiskCache_saveImage:(UIImage *)image imageData:(NSData *)downLoadImageData key:(NSString *)key;
/**
 *  拿到图片
 *
 *  @param block 异步加载的block
 *  @param key   key
 */
- (void)zhnDiskCache_GetImageWithBlock:(getImageBlock)block key:(NSString *)key;
/**
 *  从cache里拿到图片
 *
 *  @param key 键值
 *
 *  @return 图片
 */
- (UIImage *)zhnDiskCache_getImageWithKey:(NSString *)key;
/**
 *  判断是否包含图片
 *
 *  @param key 键值
 *
 *  @return 是否
 */
- (BOOL)zhnDiskCache_ContainsImageWithKey:(NSString *)key;
/**
 *  移除cache里面的内存
 *
 *  @param key 键值
 */
- (void)zhnDiskCache_removeImageWithKey:(NSString *)key;
/**
 *  清空cache内存
 */
- (void)zhnDiskCache_removeAllImages;
/**
 *  获取保存图片的名字
 *
 *  @param key 键值
 */
- (NSString *)zhnImage_getFullNameWithKey:(NSString *)key;


// 这些是私有的属性
@property (nonatomic,strong) dispatch_queue_t setGetImageQueue;
@property (nonatomic,strong) NSFileManager * fileManeger;
@property (nonatomic,copy) NSString * disCachePath;
@end
