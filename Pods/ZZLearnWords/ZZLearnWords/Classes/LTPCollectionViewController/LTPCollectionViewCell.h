//
//  LTPCollectionViewCell.h
//  LearnWord
//
//  Created by famin on 2019/4/4.
//  Copyright © 2019年 english. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTPCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *fenshuLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhengqueLabel;
@property (weak, nonatomic) IBOutlet UILabel *shibaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *nofinishLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

NS_ASSUME_NONNULL_END
