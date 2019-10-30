//
//  UIView+ZZFrame.h
//  PictureWords
//
//  Created by zhao on 2019/10/29.
//  Copyright © 2019 english. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZZFrame)

/// 判断是否是刘海屏
+ (BOOL)ltp_isIPhoneX;
/// 屏幕宽
+ (CGFloat)ltp_screenWidth;
/// 屏幕高
+ (CGFloat)ltp_screenHeight;
+ (CGFloat)ltp_navigationBarHright;
+ (CGFloat)ltp_tabbarHeight;


@end

NS_ASSUME_NONNULL_END
