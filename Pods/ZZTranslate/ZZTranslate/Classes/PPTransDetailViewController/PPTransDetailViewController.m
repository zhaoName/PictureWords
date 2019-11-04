//
//  PPTransDetailViewController.m
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import "PPTransDetailViewController.h"
#import <CommonCrypto/CommonCrypto.h>
#import "PPTransDetailModel.h"
#import "PPTransDetailView.h"
#import "PPTransDetailTableViewCell.h"
#import "MJExtension.h"

@interface PPTransDetailViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;/**< */
@property (nonatomic, strong) NSMutableArray *dataArray;/**< */

@property (nonatomic, strong) UIView *titleView;/**< */
@property (nonatomic, strong) UILabel *cLabel;/**< */
@property (nonatomic, strong) UILabel *eLabel;/**< */

@property (nonatomic, strong) UITextView *tv;/**< */
@property (nonatomic, strong) UIButton *closeBtn;/**< */

@property (nonatomic, strong) PPTransDetailModel *model;/**< */
@property (nonatomic, strong) PPTransDetailView *fanView;/**< */

@end

@implementation PPTransDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.titleView = self.titleView;
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterInputTransContent) name:@"didTouchColseBtn" object:nil];
    
    [self setupTableView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTableView
{
    if (self.isTransting) {
        [self.view addSubview:self.tv];
        [self.view addSubview:self.tableView];
    }
    else {
        self.tv.text = self.fanString;
        [self loadTransNet];
    }
    
    if (@available(iOS 11.0, *)) {
        self.tv.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)updateUI
{
    self.isTransting = NO;
    [self.fanView reloadData];
    [self.view addSubview:self.fanView];
}

- (void)loadTransNet
{
    if (self.tv.text == nil) return;
    
    // 去除行尾空格
    NSString *content = [self.tv.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *sign = [NSString stringWithFormat:@"099029538406b650%@9961NZHD4nloIg9tdLPlQ8qVzNd99ON8i3W", content];
    NSDictionary *param = @{@"q":[NSString stringWithFormat:@"%@", content], @"from":@"auto", @"to":@"auto", @"salt":@"996", @"appKey":@"099029538406b650", @"sign":[[self ltp_MD5Encrypt:sign] uppercaseString]};
    
    [[ZZMediator defaultZZMediator] cat_postRequestWithUrl:@"http://openapi.youdao.com/api" params:param success:^(id  _Nonnull responeData) {
        self.model = [PPTransDetailModel mj_objectWithKeyValues:responeData];
        [self updateUI];
        [self ltp_saveTransContent];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"error:%@", error.localizedDescription);
    }];
}

- (NSString *)ltp_MD5Encrypt:(NSString *)str
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

- (void)ltp_saveTransContent
{
    if (self.model.translation.count == 0) return;
    
    NSMutableArray *tempArr = [self.dataArray mutableCopy];
    for (NSDictionary *dict in tempArr) {
        if ([dict[@"fan"] isEqualToString:self.model.query]) {
            NSInteger index = [tempArr indexOfObject:dict];
            [self.dataArray exchangeObjectAtIndex:0 withObjectAtIndex:index];
            [self ltp_writeToFile];
            return;
        }
    }
    
    NSDictionary *dict = @{@"fan":self.model.query, @"yi":self.model.translation[0]};
    [self.dataArray insertObject:dict atIndex:0];
    [self ltp_writeToFile];
}

- (void)ltp_writeToFile
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"PPHistory.plist"];
    [self.dataArray writeToFile:path atomically:YES];
}

#pragma mark -- action

// 清空输入的翻译内容
- (void)touchCloseBtn:(UIButton *)btn
{
    NSLog(@"isTransting %d", self.isTransting);
    self.tv.text = nil;
    self.closeBtn.hidden = YES;
}

// 点击关闭翻译结构界面 进入输入翻译内容界面
- (void)willEnterInputTransContent
{
    self.tv.text = nil;
    [self.fanView removeFromSuperview];
    self.fanView = nil;
    if (![self.view.subviews containsObject:self.tv]) {
        [self.view addSubview:self.tv];
        [self.view addSubview:self.tableView];
    }
    [self.tableView reloadData];
    [self.tv becomeFirstResponder];
    self.isTransting = !self.isTransting;
}

// 点击头部 交换翻译类型
- (void)touchChangeBtn:(UIButton *)btn
{
    NSString *string = self.cLabel.text;
    self.cLabel.text = self.eLabel.text;
    self.eLabel.text = string;
}

#pragma mark --

// 点击键盘的返回按钮
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    self.closeBtn.hidden = (textView.text.length == 0);
    // 点击键盘上的返回按钮 就去翻译
    if ([text isEqualToString:@"\n"]) {
        [self.tv resignFirstResponder];
        [self loadTransNet];
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count - 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FanCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FanCell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.dataArray[indexPath.row][@"fan"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tv.text = self.dataArray[indexPath.row][@"fan"];
    [self.dataArray exchangeObjectAtIndex:0 withObjectAtIndex:indexPath.row];
    [self ltp_writeToFile];
    
    [self.tv resignFirstResponder];
    [self loadTransNet];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark -- getter or setter

- (UITextView *)tv
{
    if (!_tv) {
        _tv = [[ZZMediator defaultZZMediator] cat_fetchCustomTextView:CGRectMake(15, [UIView ltp_isIPhoneX]?88:75, [UIView ltp_screenWidth] - 30, 120) font:21 placeHolder:@"请输入要翻译的文字"];
        _tv.delegate = self;
        [_tv becomeFirstResponder];
        [_tv addSubview:self.closeBtn];
        self.closeBtn.frame = CGRectMake([UIView ltp_screenWidth] - 70, 45, 30, 30);
    }
    return _tv;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.hidden = NO;
        UIImage *closeImage = [[ZZMediator defaultZZMediator] cat_imageWithName:@"close" atClass:self.class bundleName:@""];
        [_closeBtn setImage:closeImage forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(touchCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tv.frame), [UIView ltp_screenWidth], [UIView ltp_screenHeight] - CGRectGetMaxY(self.tv.frame)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [[ZZMediator defaultZZMediator] cat_colorWithHexString:@"0xf4f7f9"];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
        path = [path stringByAppendingPathComponent:@"PPHistory.plist"];
        _dataArray = [NSMutableArray arrayWithContentsOfFile:path];
    }
    return _dataArray;
}

- (PPTransDetailView *)fanView
{
    if (!_fanView) {
        _fanView = [[PPTransDetailView alloc] initWithFrame:CGRectMake(0, [UIView ltp_isIPhoneX]?88:64, [UIView ltp_screenWidth], [UIView ltp_screenHeight] - ([UIView ltp_isIPhoneX]?88:64)) model:self.model];
    }
    return _fanView;
}

- (UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 35)];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *changeImage = [[ZZMediator defaultZZMediator] cat_imageWithName:@"trans_change" atClass:self.class bundleName:@""];
        [btn setImage:changeImage forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 30, 30);
        btn.center = _titleView.center;
        [btn addTarget:self action:@selector(touchChangeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:btn];
        
        self.cLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 35)];
        self.cLabel.text = @"English";
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

@end
