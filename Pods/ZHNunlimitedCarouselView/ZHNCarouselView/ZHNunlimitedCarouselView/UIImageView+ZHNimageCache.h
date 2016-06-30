//
//  UIImageView+ZHNimageCache.h
//  radiousConor
//
//  Created by zhn on 16/4/29.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+ZHNimage.h"
@class ZHNwebImageOperation;
@interface UIImageView (ZHNimageCache)
/**
 *  当前的下载操作
 */
@property (nonatomic,strong) ZHNwebImageOperation * currentImageOperation;
/**
 *  显示图片
 *
 *  @param url 图片url
 */
- (void)zhn_setImageWithUrl:(NSString *)url;
/**
 *  显示图片
 *
 *  @param url         图片url
 *  @param placeHolder 占位图片
 */
- (void)zhn_setImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeHolder;
/**
 *  显示图片
 *
 *  @param url  图片url
 *  @param mode 图片显示模式
 */
- (void)zhn_setImageWithUrl:(NSString *)url withContentMode:(ZHN_contentMode)mode;
/**
 *  显示图片
 *
 *  @param url         图片url
 *  @param mode        图片显示模式
 *  @param placeHolder 占位图片
 */
- (void)zhn_setImageWithUrl:(NSString *)url withContentMode:(ZHN_contentMode)mode placeHolder:(UIImage *)placeHolder;
/**
 *  显示图片
 *
 *  @param url              图片url
 *  @param mode             图片显示模式
 *  @param needDefaultImage 是否需要缓存原始图片
 *  @param placeHolder      背景图片
 */
- (void)zhn_setImageWithUrl:(NSString *)url withContentMode:(ZHN_contentMode)mode needDefaultImage:(BOOL)needDefaultImage placeHolder:(UIImage *)placeHolder;
@end
