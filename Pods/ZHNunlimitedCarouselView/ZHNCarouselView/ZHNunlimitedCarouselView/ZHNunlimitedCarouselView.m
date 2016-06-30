//
//  ZHNunlimitedCarouselView.m
//  ZHNCarouselView
//
//  Created by zhn on 16/5/24.
//  Copyright © 2016年 zhn. All rights reserved.
//
#import <objc/runtime.h>
#import "ZHNunlimitedCarouselView.h"
#import "ZHNunlimitedCell.h"
#import "UIImageView+ZHNimageCache.h"
#import "ZHNwebImageCache.h"
#define  zhnCell @"cell"
#define zhnMaxSections 100

@interface ZHNunlimitedCarouselView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic , weak) UICollectionView *collectionView;
@property (nonatomic , weak) UIPageControl *pageControl;
@property (nonatomic , strong) UIImage * placeholderImage;
@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , strong) UICollectionViewFlowLayout * flowLayout;

@property (nonatomic , assign) ZHN_contentMode imageContentMode;
@property (nonatomic , assign) pageControlMode zhnPageControlMode;
@property (nonatomic , assign) NSInteger timeIvatel;
@property (nonatomic , assign) UIViewContentMode defaulViewMode;
@property (nonatomic , copy) ZhnCarouselViewDidSelectItemBlock didSelecItemBlock;

@end




@implementation ZHNunlimitedCarouselView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self initViewWithFrame:frame];
    }
    return self;
}

- (void)initViewWithFrame:(CGRect)frame{
   
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    self.flowLayout = flowLayout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:collectionView];
    _collectionView = collectionView;
    
    
    UIPageControl * pageCtl = [[UIPageControl alloc]init];
    [self addSubview:pageCtl];
    self.pageControl = pageCtl;
    self.pageControl.userInteractionEnabled = NO;
    
    [self.collectionView registerClass:[ZHNunlimitedCell class] forCellWithReuseIdentifier:zhnCell];
}


- (void)layoutSubviews{
    [super layoutSubviews];

    self.flowLayout.itemSize = self.bounds.size;
    self.collectionView.frame = self.bounds;
    if (_imageArray.count > 0 && self.pageControl.currentPage == 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:zhnMaxSections/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }

    self.pageControl.numberOfPages = self.imageArray.count;
    CGSize pageSize = [self.pageControl sizeForNumberOfPages:self.imageArray.count];
    if (self.zhnPageControlMode == pageControlModeLeft) {
        
        self.pageControl.frame = CGRectMake(20, self.frame.size.height - pageSize.height, pageSize.width, pageSize.height);
        
    }else if(self.zhnPageControlMode == pageControlModeRight){
        
        self.pageControl.frame = CGRectMake(self.frame.size.width - 20 - pageSize.width, self.frame.size.height - pageSize.height, pageSize.width, pageSize.height);
        
    }else if(self.zhnPageControlMode == pageControlModeCenter){
        
        self.pageControl.frame = CGRectMake((self.frame.size.width - pageSize.width)/2, self.frame.size.height - pageSize.height, pageSize.width, pageSize.height);
        
    }
}

- (void)setTimeIvatel:(NSInteger)timeIvatel{
    
    _timeIvatel = timeIvatel;
    [self addTimer];
}

- (void)setPageControlNormalColor:(UIColor *)pageControlNormalColor{
    _pageControlNormalColor = pageControlNormalColor;
    self.pageControl.pageIndicatorTintColor = pageControlNormalColor;
}

- (void)setPageControlSelectColor:(UIColor *)pageControlSelectColor{
    _pageControlSelectColor = pageControlSelectColor;
    self.pageControl.currentPageIndicatorTintColor = pageControlSelectColor;
}

//====================== 属性的设置 ==========================//

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    [self setZhnPageControlMode:_zhnPageControlMode];
    [self P_zhnReloadData];
}

- (void)setDefaultZhnModeStatusViewMode:(UIViewContentMode)defaultZhnModeStatusViewMode{
    _defaultZhnModeStatusViewMode = defaultZhnModeStatusViewMode;
    [self setZhnPageControlMode:_zhnPageControlMode];
    [self P_zhnReloadData];
}

- (void)setLabelBackViewColor:(UIColor *)labelBackViewColor{
    _labelBackViewColor = labelBackViewColor;
    [self P_zhnReloadData];
}

- (void)setLabelBackViewHeight:(CGFloat)labelBackViewHeight{
    _labelBackViewHeight = labelBackViewHeight;
    [self P_zhnReloadData];
}

- (void)setNoticeLabelArray:(NSArray *)noticeLabelArray{
    _noticeLabelArray = noticeLabelArray;
    [self P_zhnReloadData];
}

- (void)setNoticeLabelFrame:(CGRect)noticeLabelFrame{
    _noticeLabelFrame = noticeLabelFrame;
    [self P_zhnReloadData];
}
- (void)setNoticeLabelTextColor:(UIColor *)noticeLabelTextColor{
    _noticeLabelTextColor = noticeLabelTextColor;
    [self P_zhnReloadData];
}

//私有的刷新数据的方法
- (void)P_zhnReloadData{
    
    [self.collectionView reloadData];
    if (_imageArray.count > 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:zhnMaxSections/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
}


#pragma mark 添加定时器
-(void) addTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timeIvatel target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer ;
    
}

#pragma mark 删除定时器
-(void) removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

-(void) nextpage{
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:zhnMaxSections /2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    NSInteger nextItem = currentIndexPathReset.item +1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem==self.imageArray.count) {
        nextItem=0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return zhnMaxSections;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZHNunlimitedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:zhnCell forIndexPath:indexPath];
    cell.backImageView.clipsToBounds = YES;
    if (_defaultZhnModeStatusViewMode) {
        cell.backImageView.contentMode = _defaultZhnModeStatusViewMode;
    }
    if (_labelBackViewColor) {
        cell.labelBackView.backgroundColor =_labelBackViewColor;
    }
    if (_labelBackViewHeight) {

        cell.labelBackView.frame = CGRectMake(0, self.frame.size.height - _labelBackViewHeight, self.frame.size.width, _labelBackViewHeight);
    }
    if (_noticeLabelArray) {
        cell.noticeLabel.text = _noticeLabelArray[indexPath.row];
    }
    if (_noticeLabelFrame.size.height > 0) {
        cell.noticeLabel.frame = _noticeLabelFrame;
    }
    if (_noticeLabelTextColor) {
        cell.noticeLabel.textColor = _noticeLabelTextColor;
    }
    
    if ([self.imageArray[indexPath.row]isKindOfClass:[NSString class]]) {
        [cell.backImageView zhn_setImageWithUrl:self.imageArray[indexPath.row] withContentMode:self.imageContentMode placeHolder:self.placeholderImage];
    }else{
        [cell.backImageView zhn_setContentMode:self.imageContentMode withImage:self.imageArray[indexPath.row] frame:cell.backImageView.frame];
    }
    
    return cell;
}


-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.didSelecItemBlock) {
        self.didSelecItemBlock(self.pageControl.currentPage);
    }
}

#pragma mark 当用户停止的时候调用
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
    
}

#pragma mark 设置页码
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = (int) (scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%self.imageArray.count;
    self.pageControl.currentPage =page;
}



+ (instancetype)zhn_instanceCarouselViewUseImageArray:(NSArray *)imageArray frame:(CGRect)frame placeHolder:(UIImage *)placeHolderImage imageContentMode:(ZHN_contentMode)contentMode pageControlMode:(pageControlMode)ctrolMode timerTime:(NSInteger)timeInterval didSelectItemBlock:(ZhnCarouselViewDidSelectItemBlock)selectItemBlock{

    ZHNunlimitedCarouselView * carouselView = [[ZHNunlimitedCarouselView alloc]initWithFrame:frame];
    carouselView.imageArray = imageArray;
    carouselView.zhnPageControlMode = ctrolMode;
    carouselView.imageContentMode = contentMode;
    carouselView.timeIvatel = timeInterval;
    carouselView.didSelecItemBlock = selectItemBlock;
    carouselView.placeholderImage = placeHolderImage;
    
    return carouselView;
}


- (void)clearCache{
    [[ZHNwebImageCache shareInstance] zhnWebImageCache_clearImages];
}



@end
