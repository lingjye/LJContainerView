//
//  BaseContainerViewController.h
//  LJContainerView
//
//  Created by txooo on 16/11/8.
//  Copyright © 2016年 领琾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJBaseContainerViewController : UIViewController
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) UIEdgeInsets tableViewEdinsets;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end
