//
//  TopToolsView.m
//  LJContainerView
//
//  Created by txooo on 16/11/8.
//  Copyright © 2016年 领琾. All rights reserved.
//

#import "LJTopToolsView.h"

@interface LJTopToolsView()

@property (nonatomic,assign) CGFloat Kpadding;
//滑块
@property (nonatomic,weak) UIView * boderView;
@property (nonatomic,strong) NSMutableArray * titleLabelSizeArray;
@property (nonatomic,strong) NSMutableArray * titleLabelArray;
@property (nonatomic,weak) UIScrollView * backScrollView;

@property (nonatomic,getter = isLayouted) BOOL layouted;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,weak) UILabel * selectedLabel;
@end

static const CGFloat KminiPadding = 20;
static const CGFloat KboderViewHeight = 3;
@implementation LJTopToolsView

- (NSMutableArray *)titleLabelArray{
    if (!_titleLabelArray) {
        _titleLabelArray = [NSMutableArray array];
    }
    return _titleLabelArray;
}

+ (LJTopToolsView *)toolViewWithTitleArray:(NSArray *)titileArray{
    LJTopToolsView *toolView = [[LJTopToolsView alloc]init];
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
        CGSize currentButtonSize = [titleString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, ViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.highLightFontSize]} context:nil].size;
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
    
    if (currentMaxWidth < ScreenWidth) {
        backScrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        self.Kpadding = (ScreenWidth - maxWidth)/(self.titileArray.count + 1);
    }else{
        self.Kpadding = KminiPadding;
    }
}

- (void)setUpTitleLabels{
    CGFloat lastLabelMaxX = 0.0;
    for (int index = 0; index < self.titileArray.count; index++) {
        UILabel * titlelabel = [[UILabel alloc]init];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        titlelabel.numberOfLines = 0;
        titlelabel.text = self.titileArray[index];
        CGSize labelSize = [self.titleLabelSizeArray[index] CGSizeValue];
        titlelabel.tag = index;
        titlelabel.font = [UIFont systemFontOfSize:self.commonfontSize];
        titlelabel.textColor = self.textColor;
        titlelabel.userInteractionEnabled = YES;
        CGFloat labelX = self.Kpadding + lastLabelMaxX;
        CGFloat labelY = 0;
        titlelabel.frame = CGRectMake(labelX, labelY, labelSize.width, ViewHeight);
        lastLabelMaxX = CGRectGetMaxX(titlelabel.frame);
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTitle:)];
        [titlelabel addGestureRecognizer:tap];
        
        [self.backScrollView addSubview:titlelabel];
        [self.titleLabelArray addObject:titlelabel];
        if (index == 0) {
            
            self.selectedLabel = titlelabel;
            self.selectedLabel.textColor = self.tintColor;
            self.selectedLabel.font = [UIFont systemFontOfSize:self.highLightFontSize];
        }
    }
    
    UIView * boderView = [[UIView alloc]init];
    boderView.backgroundColor = self.tintColor;
    boderView.frame = CGRectMake(self.selectedLabel.frame.origin.x, ViewHeight - KboderViewHeight, self.selectedLabel.frame.size.width, KboderViewHeight);
    [self.backScrollView addSubview:boderView];
    self.boderView = boderView;
    self.boderView.hidden = !self.showSlider;
}

- (void)setTitileArray:(NSArray *)titileArray{
    _titileArray = titileArray;
    [self.titleLabelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setValue:titileArray[idx] forKey:@"text"];
    }];
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
    
    if ([self.delegate respondsToSelector:@selector(toolViewSelectedIndex:animate:)]) {
        [self.delegate toolViewSelectedIndex:currentLabel.tag animate:animate];
    }
    
}

- (void)p_scrollToTitleLabel:(UILabel *)titleLabel{
    self.selectedLabel.textColor = self.textColor;
    self.selectedLabel.font = [UIFont systemFontOfSize:self.commonfontSize];
    self.selectedLabel.numberOfLines = 0;
    UILabel * tapedLabel = titleLabel;
    CGFloat currentDelta = tapedLabel.frame.origin.x - ScreenWidth / 2;
    self.selectedLabel = tapedLabel;
    
    [self.backScrollView scrollRectToVisible:CGRectMake(currentDelta + tapedLabel.frame.size.width/2, 0, ScreenWidth, ViewHeight) animated:YES];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.selectedLabel.font = [UIFont systemFontOfSize:self.highLightFontSize];
        self.selectedLabel.textColor = self.tintColor;
        self.boderView.frame = CGRectMake(tapedLabel.frame.origin.x, ViewHeight - KboderViewHeight, tapedLabel.frame.size.width, KboderViewHeight);
    }];
}

#pragma  mark -
- (void)containerContentScrollToIndex:(NSInteger)index{
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
