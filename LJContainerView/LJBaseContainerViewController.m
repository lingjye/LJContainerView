//
//  BaseContainerViewController.m
//  LJContainerView
//
//  Created by txooo on 16/11/8.
//  Copyright © 2016年 领琾. All rights reserved.
//

#import "LJBaseContainerViewController.h"

@interface LJBaseContainerViewController ()

@end

@implementation LJBaseContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITableView * backTableView = [[UITableView alloc]init];
    backTableView.contentInset = self.tableViewEdinsets;
    [self.view addSubview:backTableView];
    backTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);
//    backTableView.showsVerticalScrollIndicator = NO;
    self.tableView = backTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

@end
