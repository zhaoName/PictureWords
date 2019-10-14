//
//  UIViewController+LTPHUD.h
//  ShorthandWords
//
//  Created by zhao on 2019/5/16.
//  Copyright © 2019 english. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (LTPHUD)

- (void)ltp_showActivityIndicatorViewWithMessage:(NSString *)message;
- (void)ltp_hiddenActivityIndicatorView;
- (void)ltp_showNormalHudWithMessage:(NSString *)message autoHiddenAfterTime:(CGFloat)time;

@end

NS_ASSUME_NONNULL_END
