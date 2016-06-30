//
//  ZHNunlimitedCell.m
//  ZHNCarouselView
//
//  Created by zhn on 16/5/24.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "ZHNunlimitedCell.h"

@interface ZHNunlimitedCell()

@end


@implementation ZHNunlimitedCell

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.backImageView.frame = self.bounds;
    self.labelBackView.frame = CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40);
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UIImageView * backImageView = [[UIImageView alloc]init];
        [self addSubview:backImageView];
        self.backImageView = backImageView;
        self.backImageView.frame = self.bounds;
        backImageView.userInteractionEnabled = YES;
        backImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UIView * labeBackView = [[UIView alloc]init];
        [self addSubview:labeBackView];
        self.labelBackView = labeBackView;
        
        UILabel * noticeLabel = [[UILabel alloc]init];
        self.noticeLabel = noticeLabel;
        [labeBackView addSubview:noticeLabel];
        noticeLabel.textColor = [UIColor whiteColor];
    }
    return self;
}



@end
