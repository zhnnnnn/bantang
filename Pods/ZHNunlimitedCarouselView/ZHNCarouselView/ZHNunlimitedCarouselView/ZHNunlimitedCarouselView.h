//
//  ZHNunlimitedCarouselView.h
//  ZHNCarouselView
//
//  Created by zhn on 16/5/24.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+ZHNimage.h"

typedef void (^ZhnCarouselViewDidSelectItemBlock)(NSInteger index);
typedef NS_ENUM(NSInteger,pageControlMode){
    
    pageControlModeLeft,
    pageControlModeCenter,
    pageControlModeRight
    
};


@interface ZHNunlimitedCarouselView : UIView
/**
 *  图片的数组
 */
@property (nonatomic,strong) NSArray *imageArray;
/**
 *  pagectrol的普通颜色
 */
@property (nonatomic,strong) UIColor * pageControlNormalColor;
/**
 *  pagecontrol的选中的颜色
 */
@property (nonatomic,strong) UIColor * pageControlSelectColor;
/**
 *  系统默认的view 的 contentmode(你不需要我这些现实mode的情况下你可以用系统自带的mode)
 */
@property (nonatomic,assign) UIViewContentMode defaultZhnModeStatusViewMode;
/**
 *  标题背景的颜色(不设置颜色默认是没有颜色的)
 */
@property (nonatomic,strong) UIColor * labelBackViewColor;
/**
 *  标题背景的高度(默认的高度是40)
 */
@property (nonatomic,assign) CGFloat labelBackViewHeight;
/**
 *  提示的文字的数组(必须要设置label的frame才会有效果,label的位置是相对labelBackview的位置 labelBack的宽度是轮播图的宽度高度是可自定义的,默认的高度是40)
 */
@property (nonatomic,copy) NSArray * noticeLabelArray;
/**
 *  提示文字的frame
 */
@property (nonatomic,assign) CGRect noticeLabelFrame;
/**
 *  label 字体的颜色
 */
@property (nonatomic,strong) UIColor * noticeLabelTextColor;
/**
 *  轮播图的实例方法
 *
 *  @param imageArray       图片数组
 *  @param frame            轮播的位置
 *  @param placeHolderImage 占位图片 （占位图片一定要设置的）
 *  @param contentMode      图片的显示模式
 *  @param ctrolMode        pagectrol的显示位置
 *  @param timeInterval     自动轮播的时长
 *  @param selectItemBlock  点击事件的block回调
 *
 *  @return 轮播实例
 */
+ (instancetype)zhn_instanceCarouselViewUseImageArray:(NSArray *)imageArray frame:(CGRect)frame placeHolder:(UIImage *)placeHolderImage imageContentMode:(ZHN_contentMode)contentMode pageControlMode:(pageControlMode)ctrolMode timerTime:(NSInteger)timeInterval didSelectItemBlock:(ZhnCarouselViewDidSelectItemBlock)selectItemBlock;

/**
 *  清空缓存
 */
- (void)clearCache;
@end
