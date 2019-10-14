
//
//  UIViewController+LTPHUD.m
//  ShorthandWords
//
//  Created by zhao on 2019/5/16.
//  Copyright © 2019 english. All rights reserved.
//

#import "UIViewController+LTPHUD.h"
#import <MBProgressHUD.h>

@implementation UIViewController (LTPHUD)

- (void)ltp_showActivityIndicatorViewWithMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    if (message.length) {
        hud.label.text = message;
    }
    hud.removeFromSuperViewOnHide = YES;
}

- (void)ltp_hiddenActivityIndicatorView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)ltp_showNormalHudWithMessage:(NSString *)message autoHiddenAfterTime:(CGFloat)time
{
    if (message.length == 0) return;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    [hud hideAnimated:YES afterDelay:time];
}

@end

