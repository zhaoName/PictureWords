//
//  PPListViewController.h
//  ShorthandWords
//
//  Created by zhao on 2019/5/16.
//  Copyright © 2019 english. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPListViewController : UIViewController

@property (nonatomic, copy) void(^clickListCallBack)(NSInteger index);/**< */

@end

NS_ASSUME_NONNULL_END
