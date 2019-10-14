//
//  ImproveCollectionViewCell.m
//  LearnWord
//
//  Created by zhao on 2019/4/10.
//  Copyright © 2019 english. All rights reserved.
//

#import "ImproveCollectionViewCell.h"

@interface ImproveCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *wrongLabel;
@property (weak, nonatomic) IBOutlet UILabel *unfinishLabel;


@end

@implementation ImproveCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 5.0;
    self.clipsToBounds = YES;
}

- (void)showImproveCollectionViewCell:(NSDictionary *)dic
{
    self.titleLabel.text = [dic valueForKey:@"name"];
    NSNumber *successCount = [dic valueForKey:@"successCount"];
    NSNumber *failCount = [dic valueForKey:@"failCount"];
    NSNumber *noFinishCount = [dic valueForKey:@"noFinishCount"];
    float fenshu = (float)(100.0 / (float)(failCount.integerValue + noFinishCount.integerValue + successCount.integerValue)) * successCount.integerValue;
    self.scoreLabel.text = [NSString stringWithFormat:@"总共得分: %.1f",fenshu];
    self.rightLabel.text = [NSString stringWithFormat:@"作对个数: %zd",successCount.integerValue];
    self.wrongLabel.text = [NSString stringWithFormat:@"做错个数: %zd",failCount.integerValue];
    self.unfinishLabel.text = [NSString stringWithFormat:@"未完成: %zd",noFinishCount.integerValue];
}

@end
