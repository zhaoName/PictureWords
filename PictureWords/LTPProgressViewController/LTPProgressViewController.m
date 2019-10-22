//
//  LTPProgressViewController.m
//  LearnWord
//
//  Created by famin on 2019/4/4.
//  Copyright © 2019年 english. All rights reserved.
//

#import "LTPProgressViewController.h"
#import "ImproveCollectionViewCell.h"
#import "LTPReviewViewController.h"
#import "PPObviouslyEffectFlowLayout.h"
#import <MJRefresh.h>
#import <Masonry.h>

@interface LTPProgressViewController ()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView ;
@property (nonatomic,strong) NSMutableArray <NSDictionary*>* datasource;


@end

@implementation LTPProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"测试结果";
    self.view.backgroundColor = [[ZZMediator defaultZZMediator] cat_colorWithHexString:@"0xefefef"];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImproveCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImproveCollectionViewCell"];
}

#pragma mark -- 刷新控件

/** 下拉刷新*/
- (void)setupHeaderRefresh
{
    __weak typeof(LTPProgressViewController *) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf.datasource removeAllObjects];
        [weakSelf fetchRankData];
    }];
}

- (void)fetchRankData
{
    
}

/** 上拉加载*/
- (void)setupFooterRefresh
{
    __weak typeof(LTPProgressViewController *) weakSelf = self;
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf.datasource addObject:@{}];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.datasource removeAllObjects];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"我的错误"];
    if (dic.count == 0 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"ProgressNil"]) {
        [self ltp_tipUserToTest];
    }
    else {
        for (NSString *key in dic.allKeys) {
            NSDictionary *dicItem = [dic valueForKey:key];
            [self.datasource addObject:dicItem];
        }
        [self.collectionView reloadData];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.collectionView.frame = CGRectMake(0, NavgationHeight, ScreenWidth, ScreenHeight - NavgationHeight - TabbarHeight);
}

#pragma mark -- private method

/// tip user to Test
- (void)ltp_tipUserToTest
{
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"review_nocanjia"]];
    [self.view addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipLabel.text = @"您还未参加过测试！";
    tipLabel.textColor = [[ZZMediator defaultZZMediator] cat_colorWithHexString:@"0x666666"];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(imageV.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(200, 21));
    }];
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datasource.count ;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImproveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImproveCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dic = [self.datasource objectAtIndex:indexPath.item];
    [cell showImproveCollectionViewCell:dic];
    return cell ;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.datasource objectAtIndex:indexPath.item];
    NSString *name = [dic valueForKey:@"name"];
    NSNumber *successCount = [dic valueForKey:@"successCount"];
    NSNumber *failCount = [dic valueForKey:@"failCount"];
    NSNumber *noFinishCount = [dic valueForKey:@"noFinishCount"];
    NSInteger all = failCount.integerValue + noFinishCount.integerValue + successCount.integerValue;
    //float fenshu = (float)(100.0 / (float)(all)) * successCount.integerValue;
    __weak typeof(self)weakSelf = self ;
    
    NSString *message = [NSString stringWithFormat:@"上次挑战总共%zd道题,作对%zd道题,做错%zd道题,剩余%zd道题,是否再次挑战？", all, successCount.integerValue, failCount.integerValue, noFinishCount.integerValue];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:name message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"思考下再战" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"再次挑战" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            LTPReviewViewController *vc = [[LTPReviewViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES ;
            vc.showReviewIndex = indexPath.row;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        });
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- getter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        PPObviouslyEffectFlowLayout *fl = [[PPObviouslyEffectFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:fl];
        _collectionView.delegate = self ;
        _collectionView.dataSource = self ;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

//314 416
- (NSMutableArray<NSDictionary *> *)datasource
{
    if (_datasource == nil) {
        _datasource = [NSMutableArray array];
    }
    return _datasource ;
}
@end
