//
//  zhnToolView.m
//  bantang
//
//  Created by zhn on 16/6/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "zhnToolView.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kViewHeight self.frame.size.height

@interface zhnToolView()

@property (nonatomic,assign) CGFloat Kpadding;

@property (nonatomic,strong) NSMutableArray * titleLabelSizeArray;

@property (nonatomic,weak) UIScrollView * backScrollView;

@property (nonatomic,getter = isLayouted) BOOL layouted;

@property (nonatomic,weak) UIView * boderView;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,weak) UILabel * selectedLabel;
@end

static const CGFloat KminiPadding = 20;
static const CGFloat KboderViewHeight = 3;
@implementation zhnToolView

+ (zhnToolView *)zhnToolViewWithTitleArray:(NSArray *)titileArray{
    zhnToolView * toolView = [[zhnToolView alloc]init];
    toolView.titileArray = titileArray;
    return toolView;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (!self.isLayouted) {
    
        [self setUpPadding];
    
        [self setUpTitleLabels];
        
        self.layouted = YES;
    }
    
    
}

- (void)setUpPadding{
    
    CGFloat maxWidth = 0.0;
    self.currentIndex = 0;
    for (NSString * titleString in self.titileArray) {
        
        CGSize currentButtonSize = [titleString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, kViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.highLightFontSize]} context:nil].size;
        maxWidth  = maxWidth + currentButtonSize.width;
       [self.titleLabelSizeArray addObject:[NSValue valueWithCGSize:currentButtonSize]];
    }
    
    UIScrollView * backScrollView = [[UIScrollView alloc]init];
    backScrollView.frame =  self.bounds;
    self.backScrollView = backScrollView;
    [self addSubview:backScrollView];
    CGFloat currentMaxWidth = (self.titileArray.count + 1) * KminiPadding + maxWidth;
    backScrollView.contentSize = CGSizeMake(currentMaxWidth, self.bounds.size.height);
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.backgroundColor = [UIColor whiteColor];
    
    if (currentMaxWidth < kScreenWidth) {
        backScrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        self.Kpadding = (kScreenWidth - maxWidth)/(self.titileArray.count + 1);
    }else{
        self.Kpadding = KminiPadding;
    }
}


- (void)setUpTitleLabels{
    
    CGFloat lastLabelMaxX = 0.0;
    for (int index = 0; index < self.titileArray.count; index++) {
        UILabel * titlelabel = [[UILabel alloc]init];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        titlelabel.text = self.titileArray[index];
        CGSize labelSize = [self.titleLabelSizeArray[index] CGSizeValue];
        titlelabel.tag = index;
        titlelabel.font = [UIFont systemFontOfSize:self.commonfontSize];
        titlelabel.userInteractionEnabled = YES;
        CGFloat labelX = self.Kpadding + lastLabelMaxX;
        CGFloat labelY = 0;
        titlelabel.frame = CGRectMake(labelX, labelY, labelSize.width, kViewHeight);
        lastLabelMaxX = CGRectGetMaxX(titlelabel.frame);
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTitle:)];
        [titlelabel addGestureRecognizer:tap];
        
        [self.backScrollView addSubview:titlelabel];
        
        if (index == 0) {
           
            self.selectedLabel = titlelabel;
            self.selectedLabel.textColor = self.tintColor;
            self.selectedLabel.font = [UIFont systemFontOfSize:self.highLightFontSize];
        }
    }
    
    UIView * boderView = [[UIView alloc]init];
    boderView.backgroundColor = self.tintColor;
    boderView.frame = CGRectMake(self.selectedLabel.frame.origin.x, kViewHeight - KboderViewHeight, self.selectedLabel.frame.size.width, KboderViewHeight);
    [self.backScrollView addSubview:boderView];
    self.boderView = boderView;
}

- (void)clickTitle:(UITapGestureRecognizer *)tap{
    
    UILabel * currentLabel = (UILabel *)tap.view;
    CGFloat delta = currentLabel.tag - self.currentIndex;
    self.currentIndex = currentLabel.tag;
    [self p_scrollToTitleLabel:currentLabel];
    BOOL animate;
    if(fabs(delta) > 1){
        animate = NO;
    }else{
        animate = YES;
    }
    
    if ([self.zhnDelegate respondsToSelector:@selector(zhnToolViewSelectedIndex:animate:)]) {
        [self.zhnDelegate zhnToolViewSelectedIndex:currentLabel.tag animate:animate];
    }
    
}

- (void)p_scrollToTitleLabel:(UILabel *)titleLabel{
    
    self.selectedLabel.textColor = [UIColor blackColor];
    self.selectedLabel.font = [UIFont systemFontOfSize:self.commonfontSize];
    
    UILabel * tapedLabel = titleLabel;
    CGFloat currentDelta = tapedLabel.frame.origin.x - kScreenWidth / 2;
    self.selectedLabel = tapedLabel;
    
    [self.backScrollView scrollRectToVisible:CGRectMake(currentDelta + tapedLabel.frame.size.width/2, 0, kScreenWidth, kViewHeight) animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedLabel.font = [UIFont systemFontOfSize:self.highLightFontSize];
        self.selectedLabel.textColor = self.tintColor;
        self.boderView.frame = CGRectMake(tapedLabel.frame.origin.x, kViewHeight - KboderViewHeight, tapedLabel.frame.size.width, KboderViewHeight);
    }];
    
}

#pragma  mark - 
- (void)zhnContainerContentScrollToIndex:(NSInteger)index{
    
    UILabel * currentLabel = self.backScrollView.subviews[index+1];
    self.currentIndex = currentLabel.tag;
    [self p_scrollToTitleLabel:currentLabel];
}

- (NSMutableArray *)titleLabelSizeArray{
    if (_titleLabelSizeArray == nil) {
        _titleLabelSizeArray = [NSMutableArray array];
    }
    return _titleLabelSizeArray;
}



@end
