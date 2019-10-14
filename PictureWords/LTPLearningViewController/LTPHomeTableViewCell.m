//
//  LTPHomeTableViewCell.m
//  PictureWords
//
//  Created by zhao on 2019/9/9.
//  Copyright © 2019 english. All rights reserved.
//

#import "LTPHomeTableViewCell.h"
#import "LTPLearnWordModel.h"

@implementation LTPHomeTableViewCell

- (void)ltp_showLTPHomeTableViewCell:(NSString *)nums date:(NSString *)date indexPath:(NSIndexPath *)indexPath
{
    self.daysLabel.text = [NSString stringWithFormat:@"第 %zd 天", indexPath.row + 1];
    self.finishLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    NSString *numString = nil;
    if (nums.integerValue == 40) {
        numString = @"已学习完40个单词,去复习?";
    } else {
        numString = [NSString stringWithFormat:@"已学习 %@ 个单词", nums];
    }
    self.finishLabel.userInteractionEnabled = (nums.integerValue == 40);
    [self.finishLabel setTitle:numString forState:UIControlStateNormal];
    [self.finishLabel addTarget:self action:@selector(ltp_touchFinishBtn) forControlEvents:UIControlEventTouchUpInside];
    self.dateLabel.text = nums.integerValue == 0 ? @"您还未曾学习过！" : [NSString stringWithFormat:@"最近学习时间:%@", date];
}


- (void)ltp_touchFinishBtn
{
    if (self.ReviewBlock) {
        self.ReviewBlock();
    }
}

@end
