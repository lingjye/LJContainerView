//
//  ContainerViewController.h
//  LJContainerView
//
//  Created by txooo on 16/11/8.
//  Copyright © 2016年 领琾. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LJContainerViewControllerDelegate <NSObject>
@required
- (void)containerContentScrollToIndex:(NSInteger)index;
@end

@interface LJContainerViewController : UIViewController

//======================= 必填项 =====================================//
/**
 *  头部视图的高度 （包含轮播 + toolview）
 */
@property (nonatomic,assign) CGFloat bannerViewHeight;

/**
 *  内部内容控制器的数组
 */
@property (nonatomic,copy) NSArray <Class> * contentViewControllerArray;

/**
 *  头部视图
 */
@property (nonatomic,strong) UIView * headerView;

/**
 *  工具栏标题的数组(要和控制器数组一一对应)
 */
@property (nonatomic,copy) NSArray * toolTitleArray;
/**
 *  tool label 字体颜色
 */
@property (nonatomic,strong) UIColor * textColor;
//======================= 可选填项 =====================================//
/**
 *  toolview 的选择的颜色和下面小滑块的颜色
 */
@property (nonatomic,strong) UIColor * tintColor;
/**
 *  tool label 滑块是否显示
 */
@property (nonatomic,assign) BOOL showSlider;
/**
 *  tool label 选中情况下的字体大小
 */
@property (nonatomic,assign) CGFloat toolLabelhightLightFont;

/**
 *  tool label 普通情况下的字体
 */
@property (nonatomic,assign) CGFloat toolLabelNormalFont;
/**
 * toolView高度
 */
@property (nonatomic,assign) CGFloat toolViewHeight;
/**
 * 背景颜色
 */
@property (nonatomic,strong) UIColor *backgroundColor;

// 私有的代理
@property (nonatomic,weak) id <LJContainerViewControllerDelegate> delegate;

//网络加载后的标题 optional
- (void)updateTitleArray:(NSArray *)titleArray;

@end
