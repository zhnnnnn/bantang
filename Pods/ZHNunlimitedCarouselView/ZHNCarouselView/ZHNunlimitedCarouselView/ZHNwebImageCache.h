//
//  ZHNwebImageCache.h
//  radiousConor
//
//  Created by zhn on 16/4/29.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZHNwebImageCache : NSObject
/**
 *  图片缓存的最长时间
 */
@property (nonatomic,assign) NSInteger maxCacheTime;
/**
 *  单例方法
 *
 *  @return 单例对象
 */
+ (ZHNwebImageCache *)shareInstance;
/**
 *  保存图片
 *
 *  @param image     图片
 *  @param imageData 要保存的nsdata
 *  @param key       键值
 */
- (void)zhnWebImageCache_setImage:(UIImage *)image imageData:(NSData *)imageData key:(NSString *)key;
/**
 *  保存图片
 *
 *  @param image 图片
 *  @param key   键值
 */
- (void)zhnWebImageCache_setImage:(UIImage *)image key:(NSString *)key;
/**
 *  拿到图片
 *
 *  @param key 键值
 *
 *  @return 图片
 */
- (UIImage *)zhnWebImageCache_getImageWithKey:(NSString *)key;
/**
 *  删除图片
 *
 *  @param key 键值
 */
- (void)zhnWebImageCache_removeImageWithKey:(NSString *)key;
/**
 *  清空图片
 */
- (void)zhnWebImageCache_clearImages;
@end
