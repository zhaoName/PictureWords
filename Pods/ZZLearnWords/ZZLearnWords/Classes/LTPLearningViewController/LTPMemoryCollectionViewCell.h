//
//  LTPMemoryCollectionViewCell.h
//  ShorthandWords
//
//  Created by zhao on 2019/5/15.
//  Copyright © 2019 english. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LTPLearnWordModel;
@interface LTPMemoryCollectionViewCell : UICollectionViewCell

- (void)showLTPMemoryCollectionViewCell:(LTPLearnWordModel *)model;

@end

NS_ASSUME_NONNULL_END
