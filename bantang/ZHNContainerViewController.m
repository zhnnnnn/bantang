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

#define KviewWidth self.view.frame.size.width
#define KviewHeight self.view.frame.size.height

static const CGFloat KtoolViewHeight = 50;

@interface ZHNContainerViewController ()<UIScrollViewDelegate,UIDynamicAnimatorDelegate,UITableViewDelegate>

@property (nonatomic,weak) UIView * noticeView;

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
    
    self.contentoffSetY = - self.bannerViewHeight;
    // 动力学动画
    UIDynamicAnimator * animator = [[UIDynamicAnimator alloc]init];
    animator.delegate = self;
    self.animator = animator;
    
    UIScrollView * backScrollView = [[UIScrollView alloc]init];
    [self.view addSubview:backScrollView];
    backScrollView.frame = self.view.bounds;
    backScrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.contentViewControllerArray.count, self.view.frame.size.height);
    backScrollView.pagingEnabled = YES;
    backScrollView.delegate = self;
    backScrollView.bounces = NO;
    backScrollView.showsHorizontalScrollIndicator = NO;
    
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
    
    
    UIView * bannerView = [[UIView alloc]init];
    [self.view addSubview:bannerView];
    bannerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.bannerViewHeight);
    self.noticeView = bannerView;
    ZHNunlimitedCarouselView * carSoulView = [ZHNunlimitedCarouselView zhn_instanceCarouselViewUseImageArray:self.bannerImageArray frame:CGRectMake(0, 0, self.view.frame.size.width, self.bannerViewHeight - KtoolViewHeight) placeHolder:[UIImage imageNamed:@"tutu"] imageContentMode:ZHN_contentModeCenter pageControlMode:pageControlModeRight timerTime:10 didSelectItemBlock:^(NSInteger index) {
        NSLog(@"%ld",(long)index);
    }];
    [bannerView addSubview:carSoulView];
    
    UILabel * tempLabel = [[UILabel alloc]init];
    tempLabel.text = @"这是工具栏";
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.textColor = [UIColor whiteColor];
    [bannerView addSubview:tempLabel];
    tempLabel.frame = CGRectMake(0, self.bannerViewHeight - KtoolViewHeight, self.view.frame.size.width, KtoolViewHeight);
    tempLabel.backgroundColor = [UIColor redColor];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panTheView:)];
    [carSoulView addGestureRecognizer:pan];
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
            
            [UIView animateWithDuration:0.3 animations:^{
                self.currentShowContentController.tableView.contentOffset = CGPointMake(0, - self.bannerViewHeight);
            }];
            
        }else{
            
            CGFloat speed = [pan velocityInView:self.view].y;
            // 速度快于某个值才能响应事件
            if (speed < - 100) {
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
                    self.currentShowContentController.tableView.contentOffset = CGPointMake(0, -item.center.y - (self.bannerViewHeight/2));
            
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
        if (delta < self.bannerViewHeight - KtoolViewHeight) {
            self.noticeView.frame = CGRectMake(0, - delta, self.view.frame.size.width, self.bannerViewHeight);
            self.contentoffSetY = vc.tableView.contentOffset.y;
        }else{
            self.noticeView.frame = CGRectMake(0, -(self.bannerViewHeight - KtoolViewHeight), self.view.frame.size.width, self.bannerViewHeight);
            self.contentoffSetY = - KtoolViewHeight;
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
        self.currentShowContentController = self.childViewControllers[currentIndex];
    }
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.gesTurePaing) {
        [self.animator removeAllBehaviors];
    }
}

#pragma mark - Dynamic的代理方法
//// 结束
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator{
    self.gesTurePaing = NO;
}
// 开始
- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator{
    self.gesTurePaing = YES;
}

@end
