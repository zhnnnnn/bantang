//
//  ZHNmemoryCache.h
//  radiousConor
//
//  Created by zhn on 16/4/29.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZHNmemoryCache : NSObject
/**
 *  保存图片
 *
 *  @param image 图片
 *  @param key   键值
 */
- (void)zhnMemoryCache_setImage:(UIImage *)image withKey:(NSString *)key;
/**
 *  拿取图片
 *
 *  @param key 键值
 *
 *  @return 图片
 */
- (UIImage *)zhnMemoryCache_getImageWithKey:(NSString *)key;
/**
 *  是否包含图片
 *
 *  @param key 键值
 *
 *  @return 是否
 */
- (BOOL)zhnMemoryCache_containsImageWithKey:(NSString *)key;
/**
 *  移除图片
 *
 *  @param key 键值
 */
- (void)zhnMemoryCache_removeImageWithKey:(NSString *)key;
/**
 *  移除所有图片
 */
- (void)ZHNmemoryCache_removeAllImage;
@end
