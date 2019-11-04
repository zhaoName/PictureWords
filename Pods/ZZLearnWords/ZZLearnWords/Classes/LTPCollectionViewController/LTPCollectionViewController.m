//
//  LTPCollectionViewController.m
//  LearnWord
//
//  Created by famin on 2019/4/4.
//  Copyright © 2019年 english. All rights reserved.
//

#import "LTPCollectionViewController.h"
#import "PPXuexiViewController.h"
#import "PPDataManager.h"

@interface LTPCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableview ;
@property (nonatomic,strong) NSArray *titleArr ;

@end

@implementation LTPCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"常忘收藏";
    //self.datas = @[@"Noun",@"Verb",@"Adjective", @"Adverb",@"Pronoun",@"Preposition",@"Conjunction"];
    self.titleArr = @[@"名词",@"动词",@"形容词", @"副词",@"代词",@"介词",@"连词"];

    self.tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:_tableview];
    self.tableview.delegate = self ;
    self.tableview.dataSource = self ;
    self.tableview.tableFooterView = [UIView new];
    self.tableview.separatorColor = [[ZZMediator defaultZZMediator] cat_colorWithHexString:@"0xbfbfbf"];
    self.tableview.rowHeight = 50 ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[PPDataManager shareManager] ltp_allCollectionData].count == 0 &&
        ![[NSUserDefaults standardUserDefaults] boolForKey:@"CollectionedNil"]) {
        
        [self ltp_tipUserToCollectionWords];
    }
    [self.tableview reloadData];
}

- (void)ltp_tipUserToCollectionWords
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"你还未收藏单词，去首页学习？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"不在询问" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CollectionedNil"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - tableView

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([self class])];
    }
    NSString *key = [self.titleArr objectAtIndex:indexPath.row];
    NSDictionary *dic = [[PPDataManager shareManager] ltp_allCollectionData];
    NSInteger count = 0 ;
    if ([dic.allKeys containsObject:key]) {
        NSDictionary *dica = [dic valueForKey:key];
        count = dica.count ;
    }
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd个",count];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = [self.titleArr objectAtIndex:indexPath.row];
    NSDictionary *dic = [[PPDataManager shareManager] ltp_allCollectionData];
    if ([dic.allKeys containsObject:key]) {
        NSDictionary *dica = [dic valueForKey:key];
        if (dica.count == 0) {
            return ;
        }
        NSMutableArray *dataArr = [NSMutableArray array];
        for (NSString *key1 in dica) {
            NSDictionary *itemDic = [dica valueForKey:key1];
            [dataArr addObject:itemDic];
        }
        PPXuexiViewController *vc = [[PPXuexiViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES ;
        vc.datasource = dataArr ;
        vc.isShowCollectionButton = NO ;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
