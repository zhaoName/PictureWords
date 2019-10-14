//
//  LTPLearnWordViewController.h
//  ShorthandWords
//
//  Created by zhao on 2019/5/15.
//  Copyright © 2019 english. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTPLearnWordViewController : UIViewController

@property (nonatomic, assign) NSInteger showIndex;/**< */

@property (nonatomic, strong) void(^DisplayBlock)(NSString *nums, NSString *date);/**< */


@end

NS_ASSUME_NONNULL_END
