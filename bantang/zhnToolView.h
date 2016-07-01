//
//  zhnToolView.h
//  bantang
//
//  Created by zhn on 16/6/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNContainerViewController.h"

@protocol zhnToolViewDelegate <NSObject>
@required
- (void)zhnToolViewSelectedIndex:(NSInteger)index animate:(BOOL)animate;


@end



@interface zhnToolView : UIView <ZHNcontainerViewControllerDelegate>

+ (zhnToolView *)zhnToolViewWithTitleArray:(NSArray *)titileArray;

@property (nonatomic,copy) NSArray * titileArray;

@property (nonatomic,assign) CGFloat commonfontSize;

@property (nonatomic,assign) CGFloat highLightFontSize;

@property (nonatomic,strong) UIColor * tintColor;

@property (nonatomic,weak) id <zhnToolViewDelegate> zhnDelegate;

@end
