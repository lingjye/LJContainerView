//
//  TopToolsView.h
//  LJContainerView
//
//  Created by txooo on 16/11/8.
//  Copyright © 2016年 领琾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJContainerViewController.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ViewHeight   self.frame.size.height

@protocol LJToolViewDelegate <NSObject>
@required
- (void)toolViewSelectedIndex:(NSInteger)index animate:(BOOL)animate;
@end
@interface LJTopToolsView : UIView<LJContainerViewControllerDelegate>

+ (LJTopToolsView *)toolViewWithTitleArray:(NSArray *)titileArray;

@property (nonatomic,copy) NSArray * titileArray;

@property (nonatomic,assign) CGFloat commonfontSize;

@property (nonatomic,assign) CGFloat highLightFontSize;
@property (nonatomic,assign) BOOL showSlider;
@property (nonatomic,strong) UIColor * tintColor;
@property (nonatomic,strong) UIColor * textColor;
@property (nonatomic,weak) id <LJToolViewDelegate> delegate;

@end
