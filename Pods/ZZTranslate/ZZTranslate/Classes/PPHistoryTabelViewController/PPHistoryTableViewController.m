//
//  PPHistoryTableViewController.m
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import "PPHistoryTableViewController.h"
#import "PPTipsTableViewCell.h"

@interface PPHistoryTableViewController ()

@property (nonatomic, strong) NSMutableArray *datas;/**< */

@end

@implementation PPHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Translate History";
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"PPHistory.plist"];
    self.datas = [NSMutableArray arrayWithContentsOfFile:path];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPTipsTableViewCell *cell = [[[NSBundle bundleForClass:self.class] loadNibNamed:@"PPTipsTableViewCell" owner:self options:nil] lastObject];
    [cell ltp_showTransTableViewCell:self.datas[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ETFanViewController *fanVC = [ETFanViewController new];
//    fanVC.isTransting = NO;
//    fanVC.fanString = self.datas[indexPath.row][@"fan"];
//    [self psuhWithBackItem:fanVC];
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


@end
