//
//  PPTranslateTableViewCell.m
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import "PPTranslateTableViewCell.h"

@implementation PPTranslateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.yiTextField.inputView = [UIView new];
}


@end
