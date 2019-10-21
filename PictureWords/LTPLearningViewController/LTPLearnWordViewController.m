//
//  LTPLearnWordViewController.m
//  ShorthandWords
//
//  Created by zhao on 2019/5/15.
//  Copyright © 2019 english. All rights reserved.
//

#import "LTPLearnWordViewController.h"
#import "LTPMemoryCollectionViewCell.h"
#import "PPObviouslyEffectFlowLayout.h"
#import "PPDataManager.h"
#import "LTPLearnWordModel.h"
#import <MJExtension.h>
#import <BmobSDK/Bmob.h>

@interface LTPLearnWordViewController ()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView ;
@property (nonatomic, assign) int currentIndex;/**< */
@property (nonatomic, strong) UIButton *rightItem;/**< */
@property (nonatomic, strong) NSMutableArray *dataSources;/**< */
@property (nonatomic, strong) NSArray *unqiueIds;/**< */

@end

@implementation LTPLearnWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentIndex = 0;
    self.navigationItem.title = [NSString stringWithFormat:@"1/%zd", self.dataSources.count];
    
    // 获取数据
    self.unqiueIds = @[@"38663b252b", @"f0f9771d7e", @"00f6ade11d",@"f7badd94f7", @"85fedee261", @"1cb7c3132d", @"e340e56246", @"f007ba00ee",@"3968fe3a92", @"5d42f4af96", @"18fe784953", @"0a50ff8808", @"5c811c0c39",@"c3b96103a6", @"16729040b3", @"a652bfc5ff", @"08bd36602d", @"1a603888c8",@"5473e8d4da", @"a85f81485e", @"gfkd2FF2", @"OshavFFv", @"SvIsD00D", @"eEm2bJJb", @"9Alv0tt0"];
    self.dataSources = [[LTPLearnWordModel mj_objectArrayWithFilename:@"EnglishData.plist"][self.showIndex] mutableCopy];
    [self addRightItem];
    
    // 获取学习个数
    BmobQuery *query = [BmobQuery queryWithClassName:@"LearnWord"];
    [query getObjectInBackgroundWithId:self.unqiueIds[self.showIndex] block:^(BmobObject *object, NSError *error) {
        
    }];
    
    self.view.backgroundColor = [[ZZMediator defaultZZMediator] cat_colorWithHexString:@"0xefefef"];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[LTPMemoryCollectionViewCell class] forCellWithReuseIdentifier:@"LTPMemoryCollectionViewCell"];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 获取学习个数
    BmobQuery *query = [BmobQuery queryWithClassName:@"LearnWord"];
    [query getObjectInBackgroundWithId:self.unqiueIds[self.showIndex] block:^(BmobObject *object, NSError *error) {
        
        // 保存数据
        if (object) {
            BmobObject *saveObj = [BmobObject objectWithoutDataWithClassName:object.className objectId:object.objectId];
            NSInteger num = MAX([[object objectForKey:@"nums"] integerValue], self.currentIndex + 1);
            [saveObj setObject:[NSString stringWithFormat:@"%zd", num] forKey:@"nums"];
            [saveObj setObject:[self getCurrentDate] forKey:@"date"];
            [saveObj updateInBackground];
            
            self.DisplayBlock([NSString stringWithFormat:@"%zd", num], [self getCurrentDate]);
        } else {
            NSLog(@"LTPLearnWordViewController---保存数据失败");
        }
    }];
}

#pragma mark -- private method

- (void)addRightItem
{
    self.rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightItem.frame = CGRectMake(0, 0, 40, 40);
    [self.rightItem setImage:[UIImage imageNamed:@"collecting"] forState:UIControlStateNormal];
    [self.rightItem setImage:[UIImage imageNamed:@"collected"] forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightItem];
    
    [self rightItemState];
    [self.rightItem addTarget:self action:@selector(clickMemoryRightItem:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickMemoryRightItem:(UIButton *)btn
{
    btn.selected = !btn.selected;
    LTPLearnWordModel *model = self.dataSources[self.currentIndex];
    if (btn.selected) {
        [[PPDataManager shareManager] ltp_addCollectionModel:model];
    }
    else {
        [[PPDataManager shareManager] ltp_removeCollectionModel:model];
    }
}

- (void)rightItemState
{
    if ([[PPDataManager shareManager] ltp_isContainedModel:self.dataSources[self.currentIndex]]) {
        self.rightItem.selected = YES;
    } else {
        self.rightItem.selected = NO;
    }
}

- (NSString *)getCurrentDate
{
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    form.dateFormat = @"yyyy-MM-dd HH:mm";
    return [form stringFromDate:[NSDate date]];
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSources.count ;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LTPMemoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LTPMemoryCollectionViewCell" forIndexPath:indexPath];
    if (self.collectionView.decelerating) {
        [self rightItemState];
    }
    [cell showLTPMemoryCollectionViewCell:self.dataSources[indexPath.row]];
    return cell ;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.currentIndex = (scrollView.contentOffset.x) / ((ScreenWidth - 60) *0.85);
//    if (!self.collectionView.decelerating) {
//        [self rightItemState];
//    }
    // reset title
    self.navigationItem.title = [NSString stringWithFormat:@"%d/%zd", self.currentIndex+1, self.dataSources.count];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self rightItemState];
}

#pragma mark -- UICollectionViewDelegateFlowLayout

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(ScreenWidth-100, 500);
//}

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
- (NSMutableArray *)dataSources
{
    if (_dataSources == nil) {
        _dataSources = [NSMutableArray array];
    }
    return _dataSources ;
}

@end
