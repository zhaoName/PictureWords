//
//  PPTransDetailView.h
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class PPTransDetailModel;
@interface PPTransDetailView : UIView

- (instancetype)initWithFrame:(CGRect)frame model:(PPTransDetailModel *)model;
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
