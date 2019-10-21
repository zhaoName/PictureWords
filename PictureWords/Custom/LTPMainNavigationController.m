//
//  LTPMainNavigationController.m
//  LearnWord
//
//  Created by famin on 2019/4/4.
//  Copyright © 2019年 english. All rights reserved.
//

#import "LTPMainNavigationController.h"

@interface LTPMainNavigationController ()

@end

@implementation LTPMainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.barTintColor = [[ZZMediator defaultZZMediator] cat_colorWithHexString:@"0x44BB88"];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

@end
