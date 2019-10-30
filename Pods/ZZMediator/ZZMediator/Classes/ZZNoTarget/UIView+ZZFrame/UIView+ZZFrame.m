//
//  UIView+ZZFrame.m
//  PictureWords
//
//  Created by zhao on 2019/10/29.
//  Copyright © 2019 english. All rights reserved.
//

#import "UIView+ZZFrame.h"

@implementation UIView (ZZFrame)

/// 判断是否是刘海屏
+ (BOOL)ltp_isIPhoneX
{
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            return YES;
        }
    }
    return NO;
}

+ (CGFloat)ltp_screenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)ltp_screenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)ltp_navigationBarHright
{
    if ([self ltp_isIPhoneX]) {
        return 88;
    }else {
        return 64;
    }
}

+ (CGFloat)ltp_tabbarHeight
{
    if ([self ltp_isIPhoneX]) {
        return 83;
    }else {
        return 49;
    }
}


@end
