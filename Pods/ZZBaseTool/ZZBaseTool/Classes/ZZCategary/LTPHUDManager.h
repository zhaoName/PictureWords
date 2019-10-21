//
//  LTPHUDManager.h
//  PictureWords
//
//  Created by zhao on 2019/10/21.
//  Copyright © 2019 english. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTPHUDManager : NSObject

+ (void)ltp_showActivityIndicatorViewWithMessage:(NSString *)message view:(UIView *)view;
+ (void)ltp_hiddenActivityIndicatorFromView:(UIView *)view;
+ (void)ltp_showNormalHudWithMessage:(NSString *)message autoHiddenAfterTime:(CGFloat)time view:(UIView *)view;


@end

NS_ASSUME_NONNULL_END
