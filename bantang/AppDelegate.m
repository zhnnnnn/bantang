//
//  AppDelegate.m
//  bantang
//
//  Created by zhn on 16/6/28.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "AppDelegate.h"
#import "ZHNContainerViewController.h"
#import "TestViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIWindow * keyWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window = keyWindow;
    
    
    ZHNContainerViewController * mainVC = [[ZHNContainerViewController alloc]init];
    mainVC.contentViewControllerArray = @[[TestViewController class],[TestViewController class],[TestViewController class],[TestViewController class],[TestViewController class],[TestViewController class],[TestViewController class],[TestViewController class],[TestViewController class]];
    mainVC.bannerViewHeight = 200;
    mainVC.bannerImageArray = @[@"http://a1.hoopchina.com.cn/attachment/Day_091231/176_2698549_edf68aafc659ca6.jpg",@"http://wenwen.soso.com/p/20090316/20090316192531-1838945174.jpg",@"http://img4.imgtn.bdimg.com/it/u=1196012006,634290422&fm=21&gp=0.jpg",@"http://img1.gtimg.com/2/275/27542/2754231_500x500_0.jpg",@"http://f1.diyitui.com/63/b1/b6/64/ea/5d/1b/d9/a1/bf/f8/84/6e/e4/ab/4e.jpg"];
    mainVC.toolTitleArray = @[@"美容",@"养生",@"popular",@"古典",@"吉他",@"詹姆斯",@"科比",@"shane",@"luan"];
    mainVC.bannerPlaceHolderImage = [UIImage imageNamed:@"tutu"];
    UINavigationController * homeNavi = [[UINavigationController alloc]initWithRootViewController:mainVC];
    
    keyWindow.rootViewController = homeNavi;
    [keyWindow makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
