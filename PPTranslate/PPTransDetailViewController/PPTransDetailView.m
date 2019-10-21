//
//  PPTransDetailView.m
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import "PPTransDetailView.h"
#import "PPTransDetailModel.h"
#import "PPTransDetailTableViewCell.h"

@interface PPTransDetailView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;/**< */
@property (nonatomic, strong) PPTransDetailModel *model;/**< */

@end

@implementation PPTransDetailView


- (instancetype)initWithFrame:(CGRect)frame model:(PPTransDetailModel *)model
{
    if ([super initWithFrame:frame]) {
        self.model = model;
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)reloadData
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.model.basic.explains.count == 0 ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return self.model.basic.explains.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PPTransDetailTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PPTransDetailTableViewCell" owner:self options:nil] lastObject];
        [cell ltp_showETFanTableViewCell:self.model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FanCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FanCell"];
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"词典释义";
            cell.textLabel.textColor = [[ZZMediator defaultZZMediator] cat_colorWithHexString:@"0x666666"];
        } else {
            cell.textLabel.text = self.model.basic.explains[indexPath.row-1];
            cell.textLabel.textColor = [UIColor blackColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    clearView.backgroundColor = [UIColor clearColor];
    return clearView;
}

#pragma mark -- getter or setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [[ZZMediator defaultZZMediator] cat_colorWithHexString:@"0xf4f7f9"];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


@end
