//
//  UIImageView+ZHNradius.h
//  radiousConor
//
//  Created by zhn on 16/4/27.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZHN_contentMode){
    
    ZHN_contentModeLeft,
    ZHN_contentModeRight,
    ZHN_contentModeTop,
    ZHN_contentModeBottom,
    ZHN_contentModeCenter,
    ZHN_contentModeDefault
    
};
typedef void (^ZHNscaleImageBlock)(UIImage *);
@interface UIImageView (ZHNimage)
/**
 *  圆角
 */
@property (nonatomic,assign) CGFloat ZHN_radius;
/**
 *  image的显示类别
 */
@property (nonatomic,assign) ZHN_contentMode ZHN_imageMode;
/**
 *  显示的原始图片
 */
@property (nonatomic,strong) UIImage * ZHN_image;
/**
 *  生成的处理过的图片
 */
@property (nonatomic,strong) UIImage * handledImage;
/**
 *  生成图片的回调方法
 */
@property (nonatomic,copy) ZHNscaleImageBlock scaleImageBlock;
/**
 *  设置圆角
 *
 *  @param radius 圆角
 *  @param image  原始图片
 *  @param frame  imageview的frame
 */
- (void)zhn_setRadius:(CGFloat)radius withImage:(UIImage *)image frame:(CGRect)frame;
/**
 *  设置圆角和图片显示模式
 *
 *  @param radius 圆角
 *  @param mode   图片显示模式
 *  @param image  原始图片
 *  @param frame  imageview的frame
 */
- (void)zhn_setRadius:(CGFloat)radius contentMode:(ZHN_contentMode)mode withImage:(UIImage *)image frame:(CGRect)frame;
/**
 *  设置图片的显示模式
 *
 *  @param contentMode 图片显示模式
 *  @param image       原始图片
 *  @param frame       imageview的frame
 */
- (void)zhn_setContentMode:(ZHN_contentMode)contentMode withImage:(UIImage *)image frame:(CGRect)frame;

@end
