//
//  LTPListenViewController.m
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import "LTPListenViewController.h"
#import "LTPListenModel.h"
#import <MJExtension.h>
#import "PPListenTableViewCell.h"
#import <MJRefresh.h>
#import "LTPMusicViewController.h"
#import "LTPPlayMusicHandle.h"
#import <CommonCrypto/CommonCrypto.h>
#import "PLTPPlayListenView.h"

@interface LTPListenViewController ()<UITableViewDelegate, UITableViewDataSource, PLTPPlayListenViewDelegate>

@property (nonatomic, strong) UITableView *tableView;/**< */
@property (nonatomic, strong) NSMutableArray *dataSources;/**< */
@property (nonatomic, strong) PLTPPlayListenView *playingControlView;/**< */

@end

@implementation LTPListenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"听力训练";
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.playingControlView];
    [self setupHeaderRefresh];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark -- 刷新控件

/** 下拉刷新*/
- (void)setupHeaderRefresh
{
    __weak typeof(LTPListenViewController) *weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestNet];
    }];
}

- (void)requestNet
{
    // 第一册|1", "第一册(偶数课)|1_2", "第二册|2", "第三册|3", "第四册|4"]
    NSString *time = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *sign = [self cq_MD5Encrypt:[NSString stringWithFormat:@"Binfen_2018_%@", time]];
    NSString *url = [NSString stringWithFormat:@"http://s3.binfenyingyu.com/binfen/programitem/fetch?app_id=com.zhujiayi.nowbig&build=14&desc=0&os=ios&pageNumber=0&pageSize=100&prefix=nce_us&sign=%@&subCategory=2&timestamp=%@&version=1.7.1", sign, time];
    
    [[ZZMediator defaultZZMediator] cat_getRequestWithUrl:url params:@{} success:^(id  _Nonnull responeData) {
        self.dataSources = [LTPListenModel mj_objectArrayWithKeyValuesArray:responeData[@"datas"]];
        [LTPPlayMusicHandle ltp_shareMusicTool].musicArray = [self.dataSources mutableCopy];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPListenTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PPListenTableViewCell" owner:self options:nil] lastObject];
    [cell ltp_showPPListenTableViewCell:self.dataSources[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LTPListenModel *model = self.dataSources[indexPath.row];
    [LTPPlayMusicHandle ltp_shareMusicTool].currentIndex = indexPath.row;
    [[LTPPlayMusicHandle ltp_shareMusicTool] ltp_playerMusicWithName:model.filename url:model.mp3];
    [self.playingControlView ltp_playMusicWithModel:model];
    
    LTPMusicViewController *playingVC = [LTPMusicViewController new];
    playingVC.PPFetchCurrentPlayIndex = ^(NSInteger index) {
        [self.playingControlView ltp_playMusicWithModel:self.dataSources[index]];
    };
    [self psuhWithBackItem:playingVC];
}

// 导航栏右上角统一“返回”按钮，保留手势
- (void)psuhWithBackItem:(UIViewController *)viewController
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] init];
    leftItem.title = @"返回";
    self.navigationItem.backBarButtonItem = leftItem;
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -- ETMusicControlViewDelegateDelegate

- (void)playNextMusic
{
    [[LTPPlayMusicHandle ltp_shareMusicTool] ltp_playMusicWithPlayTypeAndisNext:YES isAutoPlay:NO];
    
    LTPListenModel *curModel = self.dataSources[[LTPPlayMusicHandle ltp_shareMusicTool].currentIndex];
    [self.playingControlView ltp_playMusicWithModel:curModel];
}

- (void)jumpToPlayingVC
{
    LTPMusicViewController *playingVC = [LTPMusicViewController new];
    playingVC.PPFetchCurrentPlayIndex = ^(NSInteger index) {
        [self.playingControlView ltp_playMusicWithModel:self.dataSources[index]];
    };
    [self.navigationController pushViewController:playingVC animated:YES];
}

#pragma mark -- setter or getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [[ZZMediator defaultZZMediator] cat_colorWithHexString:@"0xf4f7f9"];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (PLTPPlayListenView *)playingControlView
{
    if (!_playingControlView)
    {
        _playingControlView = [[PLTPPlayListenView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 60 - (iSIPhoneX?34:0), SCREEN_WIDTH, 60)];
        _playingControlView.backgroundColor = [[ZZMediator defaultZZMediator] cat_colorWithHexString:@"0xf7f7f7"];
        _playingControlView.delegate = self;
    }
    return _playingControlView;
}

- (NSMutableArray *)dataSources
{
    if (!_dataSources) {
        _dataSources = [NSMutableArray new];
    }
    return _dataSources;
}

- (NSString *)cq_MD5Encrypt:(NSString *)str
{
    if(str.length == 0) return nil;
    
    const char *cStr = [str UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    //RSLog(@"output is %@", output);
    return  output;
}

@end
