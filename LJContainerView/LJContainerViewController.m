//
//  ContainerViewController.m
//  LJContainerView
//
//  Created by txooo on 16/11/8.
//  Copyright © 2016年 领琾. All rights reserved.
//

#import "LJContainerViewController.h"
#import "LJBaseContainerViewController.h"
#import "LJDelegateContainer.h"
#import "LJTopToolsView.h"

@interface LJContainerViewController ()<LJToolViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) LJTopToolsView *toolView;

@property (nonatomic,weak) UIView * noticeView;

//@property (nonatomic,weak) UIScrollView * backScrollView;
@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,assign) CGFloat contentoffSetY;

@property (nonatomic,strong) NSMutableArray * customDelegateArray;
@property (nonatomic,assign) NSInteger selectIndex;
/**
 *  当前显示在屏幕当中的控制器
 */
@property (nonatomic,weak) LJBaseContainerViewController * currentShowContentController;
@end

@implementation LJContainerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //解决切换到非LJBaseContainerViewController后顶部偏移问题
    LJBaseContainerViewController *LJBaseContainerVC = (LJBaseContainerViewController *)self.contentViewControllerArray[_selectIndex];
    CGFloat delta = self.bannerViewHeight + LJBaseContainerVC.tableView.contentOffset.y;
    if (delta <= 0) {
        self.noticeView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.bannerViewHeight);
        self.contentoffSetY = -self.bannerViewHeight;
    }else if (delta < self.bannerViewHeight - self.toolViewHeight) {
        self.noticeView.frame = CGRectMake(0, - delta, self.view.frame.size.width, self.bannerViewHeight);
        self.contentoffSetY = LJBaseContainerVC.tableView.contentOffset.y;
    }else{
        self.noticeView.frame = CGRectMake(0, -(self.bannerViewHeight - self.toolViewHeight), self.view.frame.size.width, self.bannerViewHeight);
        self.contentoffSetY = - self.toolViewHeight;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.contentoffSetY = - self.bannerViewHeight ;
    
    [self initContentViewController];
    [self initBannerView];
}

- (void)initContentViewController{
    [self.view addSubview:self.collectionView];
}

#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.contentViewControllerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LJContainerCollectionViewCellID" forIndexPath:indexPath];
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    LJBaseContainerViewController * tempVC = (LJBaseContainerViewController *)self.contentViewControllerArray[indexPath.row];
    tempVC.tableViewEdinsets = UIEdgeInsetsMake(self.bannerViewHeight, 0, 49, 0);
    [self addChildViewController:tempVC];
    [cell addSubview:tempVC.view];
    tempVC.view.frame = cell.contentView.frame;
    [tempVC.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:(__bridge void * _Nullable)(tempVC)];
    // 让代理能够多对一
    LJDelegateContainer * container = [LJDelegateContainer containerDelegateWithFirst:self second:tempVC];
    [self.customDelegateArray addObject:container];
    tempVC.tableView.delegate = (id)container;
    self.currentShowContentController = tempVC;
    return cell;
};

- (void)updateTitleArray:(NSArray *)titleArray{
    self.toolView.titileArray = titleArray;
}

- (void)initBannerView{
    self.noticeView = self.headerView;
    [self.view addSubview:self.noticeView];
    self.noticeView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.bannerViewHeight);
    [self.noticeView addSubview:self.toolView];
}

- (NSMutableArray *)customDelegateArray{
    if (_customDelegateArray == nil) {
        _customDelegateArray = [NSMutableArray array];
    }
    return _customDelegateArray;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (context) {
        LJBaseContainerViewController * vc = (__bridge LJBaseContainerViewController *)context;
        CGFloat delta = self.bannerViewHeight + vc.tableView.contentOffset.y;
        if (delta <= 0) {
            self.noticeView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.bannerViewHeight);
            self.contentoffSetY = -self.bannerViewHeight;
        }else if (delta < self.bannerViewHeight - self.toolViewHeight) {
            self.noticeView.frame = CGRectMake(0, - delta, self.view.frame.size.width, self.bannerViewHeight);
            self.contentoffSetY = vc.tableView.contentOffset.y;
        }else{
            self.noticeView.frame = CGRectMake(0, -(self.bannerViewHeight - self.toolViewHeight), self.view.frame.size.width, self.bannerViewHeight);
            self.contentoffSetY = - self.toolViewHeight;
        }
    }
}

#pragma mark - tableView的代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (![scrollView isKindOfClass:[UITableView class]]) {
        for (LJBaseContainerViewController * tempVC in self.childViewControllers) {
            if (![tempVC isEqual:self.currentShowContentController]) {
                self.noticeView.frame = self.noticeView.frame;
                tempVC.tableView.contentOffset = CGPointMake(0, self.contentoffSetY);
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (![scrollView isKindOfClass:[UITableView class]]) {
        int currentIndex = scrollView.contentOffset.x / ScreenWidth;
        _selectIndex = currentIndex;
        if ([self.delegate respondsToSelector:@selector(containerContentScrollToIndex:)]) {
            [self.delegate containerContentScrollToIndex:currentIndex];
        }
        self.currentShowContentController = (LJBaseContainerViewController *)self.contentViewControllerArray[currentIndex];
    }
}

#pragma  mark  -  toolview的代理方法
- (void)toolViewSelectedIndex:(NSInteger)index animate:(BOOL)animate{
    _selectIndex = index;
    self.currentShowContentController = (LJBaseContainerViewController *)self.contentViewControllerArray[index];
    
    for (LJBaseContainerViewController * tempVC in self.childViewControllers) {
        tempVC.tableView.contentOffset =  CGPointMake(0, self.contentoffSetY);
    }
    
    CGRect needShowRect = CGRectMake(index * ScreenWidth, 0, ScreenWidth, ScreenHeight);
    [self.collectionView scrollRectToVisible:needShowRect animated:animate];
}

#pragma  mark - 移除监听
- (void)dealloc{
    for (LJBaseContainerViewController * contentVC in self.childViewControllers) {
        [contentVC.tableView removeObserver:self forKeyPath:@"contentOffset" context:(__bridge void * _Nullable)(contentVC.tableView)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (LJTopToolsView *)toolView{
    if (!_toolView) {
        _toolView = [LJTopToolsView toolViewWithTitleArray:self.toolTitleArray];
        self.delegate = _toolView;
        _toolView.frame = CGRectMake(0, self.bannerViewHeight - self.toolViewHeight, self.view.frame.size.width, self.toolViewHeight);
        _toolView.commonfontSize = self.toolLabelNormalFont;
        _toolView.highLightFontSize = self.toolLabelhightLightFont;
        _toolView.tintColor = self.tintColor;
        _toolView.textColor = self.textColor;
        _toolView.delegate = self;
    }
    return _toolView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.itemSize = CGSizeMake(ScreenWidth, ScreenHeight);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = self.backgroundColor ? : [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"LJContainerCollectionViewCellID"];
    }
    return _collectionView;
}

@end
