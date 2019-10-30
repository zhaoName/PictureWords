//
//  PPTipsTableViewCell.m
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import "PPTipsTableViewCell.h"

@implementation PPTipsTableViewCell

- (void)ltp_showTransTableViewCell:(NSDictionary *)dict
{
    self.fanLabel.text = dict[@"fan"];
    self.yiLabel.text = dict[@"yi"];
}

@end
