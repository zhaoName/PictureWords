//
//  LTPTestViewController.m
//  LearnWord
//
//  Created by famin on 2019/4/4.
//  Copyright © 2019年 english. All rights reserved.
//

#import "LTPTestViewController.h"
#import "LTPReviewViewController.h"
#import "PPListViewController.h"
#import "LTPCollectionViewController.h"
#import "LTPProgressViewController.h"
#import "PPDataManager.h"

@interface LTPTestViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableview;

@end

@implementation LTPTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"学而时习";
    
    self.tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableview];
    self.tableview.delegate = self;
    self.tableview.dataSource = self ;
    self.tableview.separatorColor = [[ZZMediator defaultZZMediator] cat_colorWithHexString:@"0xbfbfbf"];
    self.tableview.rowHeight = 50 ;
    UIImage *guanbiImage = [[ZZMediator defaultZZMediator] cat_imageWithName:@"review_result" atClass:UIImage.class bundleName:@"ZZLearnWords"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:guanbiImage style:UIBarButtonItemStylePlain target:self action:@selector(touchProgressRightItem)];
}

- (void)touchProgressRightItem
{
    [self.navigationController pushViewController:[LTPProgressViewController new] animated:YES];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [PPDataManager shareManager].datasource.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([self class])];
    }
    cell.imageView.image = [[ZZMediator defaultZZMediator] cat_imageWithName:@"jiyi" atClass:UIImage.class bundleName:@"ZZLearnWords"];
    cell.textLabel.text = [NSString stringWithFormat:@"测试第 %zd 天",indexPath.row+1];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ZZLearnWords" ofType:@"bundle"];
    LTPReviewViewController *vc = [[LTPReviewViewController alloc] initWithNibName:@"LTPReviewViewController" bundle:[NSBundle bundleWithPath:path]];
    vc.hidesBottomBarWhenPushed = YES ;
    vc.showReviewIndex = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)shareToYourFriends
//{
//    NSMutableDictionary *para =  [NSMutableDictionary dictionary];
//    [para SSDKSetupWeChatParamsByText:@"Good App, of course, to share" title:@"Picture Words" url:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1455060195?mt=8"] thumbImage:nil image:[UIImage imageNamed:@"xxxzzz"] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
//    [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:para onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//        if (state == SSDKResponseStateSuccess) {
//            NSLog(@"分享成功");
//        }
//    }];
//}

@end
