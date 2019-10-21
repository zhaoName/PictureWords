//
//  LTPHUDManager.m
//  PictureWords
//
//  Created by zhao on 2019/10/21.
//  Copyright © 2019 english. All rights reserved.
//

#import "LTPHUDManager.h"
#import "MBProgressHUD.h"

@implementation LTPHUDManager

+ (void)ltp_showActivityIndicatorViewWithMessage:(NSString *)message view:(UIView *)view
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    if (message.length) {
        hud.label.text = message;
    }
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)ltp_hiddenActivityIndicatorFromView:(UIView *)view
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (void)ltp_showNormalHudWithMessage:(NSString *)message autoHiddenAfterTime:(CGFloat)time view:(UIView *)view
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    if (message.length == 0) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    [hud hideAnimated:YES afterDelay:time];
}

@end
