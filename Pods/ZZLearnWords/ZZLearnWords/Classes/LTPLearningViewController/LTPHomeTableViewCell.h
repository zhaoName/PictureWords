//
//  LTPHomeTableViewCell.h
//  PictureWords
//
//  Created by zhao on 2019/9/9.
//  Copyright © 2019 english. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTPHomeTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UIButton *finishLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong) void(^ReviewBlock)(void);/**< */

- (void)ltp_showLTPHomeTableViewCell:(NSString *)nums date:(NSString *)date indexPath:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END
