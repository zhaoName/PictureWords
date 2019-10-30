//
//  PPTransDetailTableViewCell.h
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PPTransDetailModel;
@interface PPTransDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fanLabel;
@property (weak, nonatomic) IBOutlet UILabel *yiLabel;

- (void)ltp_showETFanTableViewCell:(PPTransDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
