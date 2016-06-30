//
//  zhnBaseViewController.m
//  bantang
//
//  Created by zhn on 16/6/30.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "zhnBaseViewController.h"

@interface zhnBaseViewController ()

@end

@implementation zhnBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UITableView * backTableView = [[UITableView alloc]init];
    backTableView.contentInset = self.zhn_tableViewEdinsets;
    [self.view addSubview:backTableView];
    backTableView.frame = self.view.bounds;
    backTableView.showsVerticalScrollIndicator = NO;
    self.tableView = backTableView;
    backTableView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -  写这几个方法是为了消除警告
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}


@end
