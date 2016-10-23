//
//  ZHNContainerViewController.m
//  bantang
//
//  Created by zhn on 16/6/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "ZHNContainerViewController.h"
#import "ZHNunlimitedCarouselView.h"
#import "dynamicItem.h"
#import "delegateContainer.h"
#import "zhnBaseViewController.h"
#import "zhnToolView.h"

#define KviewWidth self.view.frame.size.width
#define KviewHeight self.view.frame.size.height

// toolview 的默认高度
static const CGFloat KtoolViewHeight = 30;

@interface ZHNContainerViewController ()<UIScrollViewDelegate,UIDynamicAnimatorDelegate,UITableViewDelegate,zhnToolViewDelegate>

@property (nonatomic,weak) UIView * noticeView;

@property (nonatomic,weak) UIScrollView * backScrollView;

@property (nonatomic,weak) UIView * fakeNavibar;

@property (nonatomic,assign) CGFloat contentoffSetY;

@property (nonatomic,strong) UIDynamicAnimator * animator;

@property (nonatomic,getter = isGesTurePaing) BOOL gesTurePaing;

@property (nonatomic,strong) NSMutableArray * customDelegateArray;



/**
 *  当前显示在屏幕当中的控制器
 */
@property (nonatomic,weak) zhnBaseViewController * currentShowContentController;

@end

@implementation ZHNContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentoffSetY = - self.bannerViewHeight ;
    self.navigationController.navigationBarHidden = YES;
    // 动力学动画
    UIDynamicAnimator * animator = [[UIDynamicAnimator alloc]init];
    animator.delegate = self;
    self.animator = animator;
    

    [self initContentViewController];
    
    [self initBannerView];
    
    [self initNaViBar];
 
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}


- (void)initContentViewController{
    
    UIScrollView * backScrollView = [[UIScrollView alloc]init];
    [self.view addSubview:backScrollView];
    backScrollView.frame = self.view.bounds;
    backScrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.contentViewControllerArray.count, self.view.frame.size.height - 64);
    backScrollView.pagingEnabled = YES;
    backScrollView.delegate = self;
    backScrollView.bounces = NO;
    backScrollView.showsHorizontalScrollIndicator = NO;
    self.backScrollView = backScrollView;
    
    // 这里可以优化成按需加载(也就是显示当当前页面了在显示)
    for (int index = 0; index < self.contentViewControllerArray.count; index++) {
        
        Class contentVC = self.contentViewControllerArray[index];
        zhnBaseViewController * tempVC = [[contentVC alloc]init];
        tempVC.zhn_tableViewEdinsets = UIEdgeInsetsMake(self.bannerViewHeight, 0, 0, 0);
        [self addChildViewController:tempVC];
        [backScrollView addSubview:tempVC.view];
        tempVC.view.frame = CGRectMake(KviewWidth * index, 0, KviewWidth, KviewHeight);
        [tempVC.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)(tempVC)];
        
        // 让代理能够多对一
        delegateContainer * container = [delegateContainer containerDelegateWithFirst:self second:tempVC];
        [self.customDelegateArray addObject:container];
        tempVC.tableView.delegate = (id)container;
        
        if (index == 0) {
            self.currentShowContentController = tempVC;
        }
    }
    
}


- (void)initBannerView{
    
    UIView * bannerView = [[UIView alloc]init];
    [self.view addSubview:bannerView];
    bannerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.bannerViewHeight);
    self.noticeView = bannerView;
    ZHNunlimitedCarouselView * carSoulView = [ZHNunlimitedCarouselView zhn_instanceCarouselViewUseImageArray:self.bannerImageArray frame:CGRectMake(0, 0, self.view.frame.size.width, self.bannerViewHeight - KtoolViewHeight) placeHolder:self.bannerPlaceHolderImage imageContentMode:ZHN_contentModeCenter pageControlMode:pageControlModeRight timerTime:10 didSelectItemBlock:^(NSInteger index) {
        NSLog(@"%ld",(long)index);
    }];
    [bannerView addSubview:carSoulView];
    
    zhnToolView * toolView = [zhnToolView zhnToolViewWithTitleArray:self.toolTitleArray];
    self.delegate = toolView;
    [bannerView addSubview:toolView];
    toolView.frame = CGRectMake(0, self.bannerViewHeight - KtoolViewHeight, self.view.frame.size.width, KtoolViewHeight);
    toolView.commonfontSize = 16;
    toolView.highLightFontSize = 18;
    toolView.tintColor = [UIColor redColor];
    toolView.zhnDelegate = self;
    
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panTheView:)];
    [carSoulView addGestureRecognizer:pan];
    
}

- (void)initNaViBar{
    
    UIView * naviBar = [[UIView alloc]init];
    [self.view addSubview:naviBar];
    naviBar.backgroundColor = [UIColor blueColor];
    naviBar.frame = CGRectMake(0, 0, KviewWidth, 64);
    self.fakeNavibar = naviBar;
    naviBar.alpha = 0;
    
}


- (NSMutableArray *)customDelegateArray{
    if (_customDelegateArray == nil) {
        _customDelegateArray = [NSMutableArray array];
    }
    return _customDelegateArray;
}

- (void)panTheView:(UIPanGestureRecognizer *)pan{
    
    static CGPoint startPoint;
    static CGFloat currentOffsety;
    if (pan.state == UIGestureRecognizerStateBegan) {
        startPoint = [pan locationInView:self.view];
        currentOffsety = self.contentoffSetY;
        [self.animator removeAllBehaviors];
    }else if(pan.state == UIGestureRecognizerStateChanged){
        
        CGPoint changePoint = [pan locationInView:self.view];
        CGFloat delta = startPoint.y - changePoint.y;
        self.currentShowContentController.tableView.contentOffset = CGPointMake(0, delta + currentOffsety);
        
    }else if(pan.state == UIGestureRecognizerStateChanged || pan.state == UIGestureRecognizerStateEnded){
        
        CGPoint changePoint = [pan locationInView:self.view];
        CGFloat delta = startPoint.y - changePoint.y;
        
        if (delta < 0) {
            
            [UIView animateWithDuration:0.15 animations:^{
                self.currentShowContentController.tableView.contentOffset = CGPointMake(0, - self.bannerViewHeight);
            }];
            
        }else{
            CGFloat speed = [pan velocityInView:self.view].y;
            // ios 10 莫名speed特别大的时候貌似speed就变0了，具体原因google了也没google出来
            if (speed == 0) {
                speed = -2500;
            }
            // 速度快于某个值才能响应事件
            if (speed < - 100) {
                // 这里算是这个库非常非常重要的一点了
                dynamicItem * item = [dynamicItem new];
                UIDynamicItemBehavior * inertialBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[item]];
                [inertialBehavior addLinearVelocity:CGPointMake(0, speed) forItem:item];
                inertialBehavior.resistance = 2.0;
                CGPoint currentPoint = self.noticeView.center;
                item.center = CGPointMake(0, currentPoint.y);
                
                inertialBehavior.action = ^(){
    
                    if (item.center.y >= - KtoolViewHeight) {
                        self.noticeView.center = CGPointMake(currentPoint.x, item.center.y);
                    }else{
                        self.noticeView.center = CGPointMake(currentPoint.x, - KtoolViewHeight);
                    }
                    CGFloat currentY =  - item.center.y - (self.bannerViewHeight/2);
                    if (currentY > self.currentShowContentController.tableView.contentSize.height - KviewHeight) {
                        
                    }else{
                        self.currentShowContentController.tableView.contentOffset = CGPointMake(0, -item.center.y - (self.bannerViewHeight/2));
                    }
                };
                [self.animator addBehavior:inertialBehavior];
            }
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if (context) {
        zhnBaseViewController * vc = (__bridge zhnBaseViewController *)context;
        
        CGFloat delta = self.bannerViewHeight + vc.tableView.contentOffset.y;
        if (delta < self.bannerViewHeight - KtoolViewHeight - 64) {
            self.noticeView.frame = CGRectMake(0, - delta, self.view.frame.size.width, self.bannerViewHeight);
            self.contentoffSetY = vc.tableView.contentOffset.y;
            CGFloat scale = delta / (self.bannerViewHeight - KtoolViewHeight - 64);
            self.fakeNavibar.alpha = scale;
        }else{
            self.fakeNavibar.alpha = 1;
            self.noticeView.frame = CGRectMake(0, -(self.bannerViewHeight - KtoolViewHeight - 64), self.view.frame.size.width, self.bannerViewHeight);
            self.contentoffSetY = - KtoolViewHeight - 64;
        }
    }
}

#pragma mark - tableView的代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (![scrollView isKindOfClass:[UITableView class]]) {
        
        for (zhnBaseViewController * tempVC in self.childViewControllers) {
            if (![tempVC isEqual:self.currentShowContentController]) {
                 tempVC.tableView.contentOffset = CGPointMake(0, self.contentoffSetY);
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (![scrollView isKindOfClass:[UITableView class]]) {
        
        int currentIndex = scrollView.contentOffset.x / KviewWidth;
        
        if ([self.delegate respondsToSelector:@selector(zhnContainerContentScrollToIndex:)]) {
            [self.delegate zhnContainerContentScrollToIndex:currentIndex];
        }
        
        self.currentShowContentController = self.childViewControllers[currentIndex];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.gesTurePaing) {
        [self.animator removeAllBehaviors];
    }
}

#pragma mark - Dynamic的代理方法
// 结束
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator{
    self.gesTurePaing = NO;
}
// 开始
- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator{
    self.gesTurePaing = YES;
}

#pragma  mark  -  toolview的代理方法
- (void)zhnToolViewSelectedIndex:(NSInteger)index animate:(BOOL)animate{
    
    self.currentShowContentController = self.childViewControllers[index];
    
    for (zhnBaseViewController * tempVC in self.childViewControllers) {
        tempVC.tableView.contentOffset =  CGPointMake(0, self.contentoffSetY);
    }
    
    
    CGRect needShowRect = CGRectMake(index * KviewWidth, 0, KviewWidth, KviewHeight);
    [self.backScrollView scrollRectToVisible:needShowRect animated:animate];
   
}


#pragma  mark - 移除监听
- (void)dealloc{
    
    for (zhnBaseViewController * contentVC in self.childViewControllers) {
        [contentVC.tableView removeObserver:self forKeyPath:@"contentOffset" context:(__bridge void * _Nullable)(contentVC.tableView)];
    }
    
}


@end
