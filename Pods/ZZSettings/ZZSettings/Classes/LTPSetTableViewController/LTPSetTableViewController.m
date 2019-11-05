//
//  LTPSetTableViewController.m
//  PictureWords
//
//  Created by zhao on 2019/9/11.
//  Copyright © 2019 english. All rights reserved.
//

#import "LTPSetTableViewController.h"
#import "LTPSuggestViewController.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <ZZMediator/ZZMediator+ZZBaseTool.h>
#import <ZZMediator/ZZMediator+ZZLogin.h>
#import <ZZMediator/ZZMediator+ZZLearnWords.h>
#import <ZZMediator/ZZConstString.h>

@interface LTPSetTableViewController ()

@property (weak, nonatomic) IBOutlet UIButton *avaterBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;



@end

@implementation LTPSetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logoutBtn.layer.cornerRadius = 5.0;
    self.avaterBtn.layer.cornerRadius = 75;
    self.avaterBtn.clipsToBounds = YES;
    self.navigationItem.title = @"设置";
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    CGFloat caches = [self ltp_calculateFileSize:path];
    self.cacheLabel.text = [NSString stringWithFormat:@"%.02f M", caches/1000.0/1000.0];
    
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:kLTPWordsNickName];
    NSMutableString *phone = [[[NSUserDefaults standardUserDefaults] objectForKey:kLTPWordsPhone] mutableCopy];
    [phone replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.nickNameLabel.text = nickName.length == 0 ? phone : nickName;
    
    
    [self.avaterBtn sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568228801428&di=cc2ffca8fb13f2b882def21a7a594628&imgtype=0&src=http%3A%2F%2Fimg.qqzhi.com%2Fuploads%2F2018-12-09%2F104843548.jpg"] forState:UIControlStateNormal placeholderImage:[[ZZMediator defaultZZMediator] cat_imageWithName:@"logo" atClass:self.class bundleName:@""]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self ltp_goodComment];
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        [self ltp_clearCache];
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        LTPSuggestViewController *su = [LTPSuggestViewController new];
        su.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:su animated:YES];
    }
    else if (indexPath.section == 1 && indexPath.row == 1) {
        UIViewController *coll = [[ZZMediator defaultZZMediator] learn_fetchCollectionVC];
        coll.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:coll animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (IBAction)ltp_touchLogoutBtn:(UIButton *)sender
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"您确定要退出登录吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLTPWordsPhone];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[ZZMediator defaultZZMediator] login_fetchLoginVC];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark -- private method

- (void)ltp_goodComment
{
    NSURL *commentUrl = [NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1479718890&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"];
    if ([[UIApplication sharedApplication] canOpenURL:commentUrl]) {
        [[UIApplication sharedApplication] openURL:commentUrl];
    }
}


- (void)ltp_clearCache
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"您确定要清空缓存吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.cacheLabel.text = @"0.00 M";
            });
        });
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (NSUInteger)ltp_calculateFileSize:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //是否为文件
    BOOL isFile = NO;
    //判断文件或文件夹是否存在(也就是判断filePath是否是一个正确的路径)
    BOOL isExist = [fileManager fileExistsAtPath:filePath isDirectory:&isFile];
    if(!isExist) return 0;// 不存在返回0
    
    if(!isFile)//是文件
    {
        return [[fileManager attributesOfItemAtPath:filePath error:nil][NSFileSize] integerValue];
    }
    else //是文件夹
    {
        //遍历文件夹中的所有内容
        NSArray *subPaths = [fileManager subpathsAtPath:filePath];
        NSUInteger totalBytes = 0;
        for(NSString *subPath in subPaths)
        {
            //CQLog(@"文件夹下的全部内容的路径：%@", subPath);
            //获取全路径
            NSString *fullPath = [filePath stringByAppendingString:[NSString stringWithFormat:@"/%@", subPath]];
            BOOL dir= NO;
            [fileManager fileExistsAtPath:fullPath isDirectory:&dir];
            
            if(!dir)//是文件就计算大小,注意文件夹是没有大小的所以就不用计算了
            {
                totalBytes += [[fileManager attributesOfItemAtPath:fullPath error:nil][NSFileSize] integerValue];
            }
        }
        return totalBytes;
    }
}


@end
