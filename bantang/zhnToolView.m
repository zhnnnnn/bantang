//
//  zhnToolView.m
//  bantang
//
//  Created by zhn on 16/6/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "zhnToolView.h"

@interface zhnToolView()

@property (nonatomic,copy) NSArray * titileArray;

@end



static const CGFloat Kpadding = 10;
@implementation zhnToolView

+ (zhnToolView *)zhnToolViewWithTitleArray:(NSArray *)titileArray{
    zhnToolView * toolView = [[zhnToolView alloc]init];
    toolView.titileArray = titileArray;
    return toolView;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    for (int index = 0; index < self.titileArray.count; index++) {
        NSString * titleString = self.titileArray[index];
        CGSize currentButtonSize = [titleString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
        
        UIButton * titleButton = [[UIButton alloc]init];
        [titleButton setTitle:titleString forState:UIControlStateNormal];
        [titleButton setTitle:titleString forState:UIControlStateHighlighted];
        
        
        
    }
    
    
}



@end
