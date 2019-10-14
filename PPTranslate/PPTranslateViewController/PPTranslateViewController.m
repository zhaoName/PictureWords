//
//  PPTranslateViewController.m
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import "PPTranslateViewController.h"
#import "PPTranslateTableViewCell.h"
#import "PPTipsTableViewCell.h"
#import <Masonry.h>
#import "PPHistoryTableViewController.h"
#import "PPTransDetailViewController.h"
#import "LTPListenViewController.h"

@interface PPTranslateViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;/**< */
@property (nonatomic, strong) NSMutableArray *dataSources;/**< 数据源*/
@property (nonatomic, strong) UIView *titleView;/**< */
@property (nonatomic, strong) UILabel *cLabel;/**< */
@property (nonatomic, strong) UILabel *eLabel;/**< */

@end

@implementation PPTranslateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.titleView = self.titleView;
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    }
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ear"] style:UIBarButtonItemStylePlain target:self action:@selector(touchRightBarItem)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"PPHistory.plist"];
    self.dataSources = [NSMutableArray arrayWithContentsOfFile:path];
    [self.tableView reloadData];
}

#pragma mark -- Action
- (void)touchChangeBtn:(UIButton *)btn
{
    NSString *string = self.cLabel.text;
    self.cLabel.text = self.eLabel.text;
    self.eLabel.text = string;
}

- (void)clickMoreBtn:(UIButton *)btn
{
    if (btn.tag == 1001) {
        PPHistoryTableViewController *historyVC = [PPHistoryTableViewController new];
        historyVC.hidesBottomBarWhenPushed = YES;
        [self psuhWithBackItem:historyVC];
    }
}

- (void)touchRightBarItem
{
    LTPListenViewController *listenVC = [[LTPListenViewController alloc] init];
    listenVC.hidesBottomBarWhenPushed = YES;
    [self psuhWithBackItem:listenVC];
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

#pragma mark  -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 ) {
        return 1;
    } else if (section == 2) {
        return 3;
    } else {
        return MIN(3, self.dataSources.count);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        PPTranslateTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PPTranslateTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.yiTextField becomeFirstResponder];
        return cell;
    }
    else {
        PPTipsTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PPTipsTableViewCell" owner:self options:nil] lastObject];
        [cell ltp_showTransTableViewCell:self.dataSources[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0.1;
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 125.0;
    }
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) return nil;
    
    UIView *conView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UILabel *boldLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 150, 30)];
    boldLabel.text = (section== 1) ? @"Translate History" : @"Daily";
    boldLabel.font = [UIFont boldSystemFontOfSize:18];
    [conView addSubview:boldLabel];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(SCREEN_WIDTH - 70, 10, 50, 30);
    [moreBtn setTitle:(section== 1) ? @"More >":nil forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor ltp_colorWithHexString:@"999999"] forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [conView addSubview:moreBtn];
    moreBtn.tag = 1000+section;
    [moreBtn addTarget:self action:@selector(clickMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return conView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPTransDetailViewController *fanVC = [PPTransDetailViewController new];
    fanVC.hidesBottomBarWhenPushed = YES;
    if (indexPath.section ==0 && indexPath.row == 0) {
        fanVC.isTransting = YES;
        [self psuhWithBackItem:fanVC];
    }
    else if (indexPath.section == 1) {
        fanVC.isTransting = NO;
        fanVC.fanString = self.dataSources[indexPath.row][@"fan"];
        [self psuhWithBackItem:fanVC];
    }
}

#pragma mark -- getter or setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 35)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"trans_change"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 30, 30);
        btn.center = _titleView.center;
        [btn addTarget:self action:@selector(touchChangeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:btn];
        
        self.cLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 35)];
        self.cLabel.text = @"English";
        self.cLabel.textAlignment = NSTextAlignmentRight;
        self.cLabel.font = [UIFont systemFontOfSize:18];
        self.cLabel.textColor = UIColor.whiteColor;
        [_titleView addSubview:self.cLabel];
        
        self.eLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 75, 35)];
        self.eLabel.text = @"Chinese";
        self.eLabel.font = [UIFont systemFontOfSize:18];
        self.eLabel.textColor = UIColor.whiteColor;
        [_titleView addSubview:self.eLabel];
    }
    return _titleView;
}

- (NSMutableArray *)dataSources
{
    if (!_dataSources) {
        _dataSources = [NSMutableArray new];
    }
    return _dataSources;
}

@end
