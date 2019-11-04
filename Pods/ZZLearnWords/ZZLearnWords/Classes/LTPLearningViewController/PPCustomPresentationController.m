//
//  PPCustomPresentationController.m
//  ShorthandWords
//
//  Created by zhao on 2019/5/14.
//  Copyright © 2019 english. All rights reserved.
//

#import "PPCustomPresentationController.h"

@interface PPCustomPresentationController ()
@property (nonatomic, strong) UIView *bgView; /**< */
@end

@implementation PPCustomPresentationController

- (void)containerViewWillLayoutSubviews
{
    [super containerViewWillLayoutSubviews];
    // 改变被推入试图view的大小
    self.presentedView.frame = self.cusFrame; //[UIView ltp_isIPhoneX] ? CGRectMake([UIView ltp_screenWidth] - 130, 75, 120, 120) : CGRectMake([UIView ltp_screenWidth] - 130, 55, 120, 120);
    // 背景view
    self.bgView = [[UIView alloc] initWithFrame:self.containerView.bounds];
    self.bgView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
    [self.containerView insertSubview:self.bgView atIndex:0];
    
    [self.bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBgView:)]];
}

// 点击背景view 菜单式图消失
- (void)dismissBgView:(UITapGestureRecognizer *)tapGes
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
