//
//  PPListenTableViewCell.m
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import "PPListenTableViewCell.h"
#import "LTPListenModel.h"

@implementation PPListenTableViewCell

- (void)ltp_showPPListenTableViewCell:(LTPListenModel *)model
{
    self.titleLabel.text = model.title;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.update_time/1000];
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"yyyy-MM-dd"];
    
    [self.updatebtn setTitle:[NSString stringWithFormat:@" %@", [form stringFromDate:date]] forState:UIControlStateNormal];
    self.sizeLabel.text = [NSString stringWithFormat:@"%.1fM", model.size / 1000.0];
}


@end
