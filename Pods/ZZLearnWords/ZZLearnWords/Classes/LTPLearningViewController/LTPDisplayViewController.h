//
//  LTPDisplayViewController.h
//  ShorthandWords
//
//  Created by zhao on 2019/5/14.
//  Copyright © 2019 english. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTPDisplayViewController : UIViewController

@property (nonatomic, strong) void (^didSelectedRow)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
