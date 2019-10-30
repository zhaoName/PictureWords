//
//  LTPHomeViewController.m
//  LearnWord
//
//  Created by famin on 2019/4/4.
//  Copyright © 2019年 english. All rights reserved.
//

#import "LTPHomeViewController.h"
#import "LTPLearnWordViewController.h"
#import "LTPDisplayViewController.h"
#import "PPCustomPresentationController.h"
#import "MJRefresh.h"
#import "LTPHomeTableViewCell.h"
#import <BmobSDK/Bmob.h>
#import "LTPHomeModel.h"
#import "LTPReviewViewController.h"
#import "LTPTestViewController.h"
#import "LTPCollectionViewController.h"

@interface LTPHomeViewController ()<UITableViewDelegate,UITableViewDataSource, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic, assign) BOOL isPresented; /**< 是否弹出试图*/
@property (nonatomic, strong) NSMutableArray *dataSouces;/**< */

@end

@implementation LTPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"看图学单词";
    
    self.tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:_tableview];
    self.tableview.delegate = self ;
    self.tableview.dataSource = self ;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.rowHeight = 50 ;
    
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_bg"]];
    imageV.frame = CGRectMake(0, 0, [UIView ltp_screenWidth], 207);
    self.tableview.tableHeaderView = imageV;
    
    [self addBarButtonItem];
    
    [[ZZMediator defaultZZMediator] cat_showIndicatorHUDWithMessage:@"" view:self.view];
    BmobQuery *query = [BmobQuery queryWithClassName:@"LearnWord"];
    query.cachePolicy = kBmobCachePolicyNetworkElseCache;
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {

        [[ZZMediator defaultZZMediator] cat_hideIndicatorHUD:self.view];
        self.dataSouces = [array mutableCopy];
        [self.tableview reloadData];
    }];
}

- (void)addBarButtonItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"progress_list"] style:UIBarButtonItemStylePlain target:self action:@selector(ltp_touchRightBarButtonItem)];
}

- (void)ltp_touchRightBarButtonItem
{
    LTPDisplayViewController *menuVC = [[LTPDisplayViewController alloc] init];
    menuVC.modalPresentationStyle = UIModalPresentationCustom;
    menuVC.transitioningDelegate = self;
    
    menuVC.didSelectedRow = ^(NSInteger index) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //self.dataSouces = [LTPLearnWordModel mj_objectArrayWithFilename:@"EnglishData.plist"];
            if (index == 0) {
                LTPTestViewController *testVC = [[LTPTestViewController alloc] init];
                testVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:testVC animated:YES];
            }
            else if (index == 1) {
                LTPCollectionViewController *testVC = [[LTPCollectionViewController alloc] init];
                testVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:testVC animated:YES];
            }
        });
    };
    [self presentViewController:menuVC animated:YES completion:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (@available(iOS 11.0, *)) {
        self.tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableview.frame = CGRectMake(0, [UIView ltp_navigationBarHright], [UIView ltp_screenWidth], [UIView ltp_screenHeight] - [UIView ltp_navigationBarHright] - [UIView ltp_tabbarHeight]);
}

#pragma mark -- 刷新控件

/** 下拉刷新*/
- (void)setupHeaderRefresh
{
    __weak typeof(LTPHomeViewController *) weakSelf = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf fetchRankData];
    }];
}

- (void)fetchRankData
{
    
}

/** 上拉加载*/
- (void)setupFooterRefresh
{
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
    }];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSouces.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LTPHomeTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LTPHomeTableViewCell" owner:nil options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell ltp_showLTPHomeTableViewCell:[self.dataSouces[indexPath.row] objectForKey:@"nums"] date:[self.dataSouces[indexPath.row] objectForKey:@"date"] indexPath:indexPath];
    cell.ReviewBlock = ^{
        LTPReviewViewController *reviewVC = [[LTPReviewViewController alloc] init];
        reviewVC.hidesBottomBarWhenPushed = YES;
        reviewVC.showReviewIndex = indexPath.row;
        [self.navigationController pushViewController:reviewVC animated:YES];
    };
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LTPLearnWordViewController *vc = [[LTPLearnWordViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES ;
    vc.showIndex = indexPath.row;
    
    vc.DisplayBlock = ^(NSString * _Nonnull nums, NSString * _Nonnull date) {
        LTPHomeTableViewCell *cell = (LTPHomeTableViewCell *)[self.tableview cellForRowAtIndexPath:indexPath];
        NSString *numString = nil;
        if (nums.integerValue == 40) {
            numString = @"已学习完40个单词,去复习?";
        } else {
            numString = [NSString stringWithFormat:@"已学习 %@ 个单词", nums];
        }
        cell.finishLabel.userInteractionEnabled = (nums.integerValue == 40);
        [cell.finishLabel setTitle:numString forState:UIControlStateNormal];
        cell.dateLabel.text = [NSString stringWithFormat:@"最近学习时间:%@", date];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 207;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark -- 转场动画
#pragma mark -- UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    PPCustomPresentationController *cto = [[PPCustomPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    cto.cusFrame = [UIView ltp_isIPhoneX] ? CGRectMake([UIView ltp_screenWidth] - 130, 75, 120, 120) : CGRectMake([UIView ltp_screenWidth] - 130, 55, 120, 120);
    return cto;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isPresented = NO;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.isPresented = YES;
    return self;
}

#pragma mark -- UIViewControllerAnimatedTransitioning

// 动画持续时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.isPresented ? [self animationForViewPresented:transitionContext] : [self animationForViewDismissed:transitionContext];
}

// 弹出试图动画
- (void)animationForViewPresented:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 取出弹出试图的view
    UIView *presentedView = [transitionContext viewForKey:UITransitionContextToViewKey];
    // 将弹出试图的view加在容器containerView上
    [transitionContext.containerView addSubview:presentedView];
    
    // 动画
    presentedView.transform = CGAffineTransformMakeScale(1.0, 0);
    presentedView.layer.anchorPoint = CGPointMake(0.5, 0);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        presentedView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        // 必须在动画结束时告诉上下文 动画结束
        [transitionContext completeTransition:YES];
    }];
}

// 试图消失动画
- (void)animationForViewDismissed:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 取出消失的view
    UIView *dismissView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    // 动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        dismissView.transform = CGAffineTransformMakeScale(1.0, 0.0001);
    } completion:^(BOOL finished) {
        // 必须告诉转场上下文你已经完成动画
        [transitionContext completeTransition:YES];
    }];
}

#pragma mark -- getter

- (NSMutableArray *)dataSouces
{
    if (!_dataSouces) {
        _dataSouces = [NSMutableArray new];
    }
    return _dataSouces;
}

@end
