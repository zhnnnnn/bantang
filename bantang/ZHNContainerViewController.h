//
//  ZHNContainerViewController.h
//  bantang
//
//  Created by zhn on 16/6/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHNContainerViewController : UIViewController
/**
 *  头部视图的高低 （包含轮播 + toolview）
 */
@property (nonatomic,assign) CGFloat bannerViewHeight;

/**
 *  内部内容控制器的数组
 */
@property (nonatomic,copy) NSArray <Class> * contentViewControllerArray;

/**
 *  banner图片的数组
 */
@property (nonatomic,copy) NSArray * bannerImageArray;


@end
