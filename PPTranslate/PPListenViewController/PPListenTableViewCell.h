//
//  PPListenTableViewCell.h
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LTPListenModel;
@interface PPListenTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *updatebtn;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

- (void)ltp_showPPListenTableViewCell:(LTPListenModel *)model;

@end

NS_ASSUME_NONNULL_END
