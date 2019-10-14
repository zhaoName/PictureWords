//
//  LTPMainTabBarController.m
//  LearnWord
//
//  Created by famin on 2019/4/4.
//  Copyright © 2019年 english. All rights reserved.
//

#import "LTPMainTabBarController.h"
#import "LTPMainNavigationController.h"
#import "LTPHomeViewController.h"
#import "PPTranslateViewController.h"
#import "LTPSetTableViewController.h"

@interface MainTabBarItem : UITabBarItem
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage titleColor:(UIColor *)titleColor selectedTitleColor:(UIColor *)selectedTitleColor ;
@end

@implementation MainTabBarItem
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage titleColor:(UIColor *)titleColor selectedTitleColor:(UIColor *)selectedTitleColor
{
    if ([super initWithTitle:title image:image selectedImage:selectedImage]) {
        
        self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.selectedImage = [self.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName : titleColor}
                            forState:UIControlStateNormal];
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName : selectedTitleColor}
                            forState:UIControlStateSelected];
    }
    return self ;
}
@end
@interface LTPMainTabBarController ()

@end

@implementation LTPMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.barTintColor = [UIColor whiteColor];
    NSArray <Class>*vcClassArr = @[
                                   [LTPHomeViewController class],
                                   [PPTranslateViewController class],
                                   [LTPSetTableViewController class],
                                   //[LTPProgressViewController class]
                                   ];
    UIColor *defaultColor = UIColorWithHex(0xbfbfbf);
    UIColor *selectedColor = [UIColor ltp_mainRedColor];
    NSArray <NSString *>*nameArr = @[@"学单词", @"翻译", @"我的"];
    NSArray <UIImage *>*defaultImages = @[
                                          [UIImage imageNamed:@"memory_normal"],
                                          [UIImage imageNamed:@"trans_normal"],
                                          [UIImage imageNamed:@"me_normal"],
                                          //[UIImage imageNamed:@"progress_normal"]
                                          ];
    NSArray <UIImage *>*selectedImages = @[
                                           [UIImage imageNamed:@"memory_selected"],
                                           [UIImage imageNamed:@"trans_selected"],
                                           [UIImage imageNamed:@"me_selected"],
                                           //[UIImage imageNamed:@"progress_selected"]
                                           ];
    NSMutableArray *viewcontrollers = [NSMutableArray array];
    for (int i = 0; i < vcClassArr.count; i++) {
        UIViewController *vc = [[vcClassArr[i] alloc] init];
        if (i == 2) {
            vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LTPSetTableViewController"];
        }
        LTPMainNavigationController *root = [[LTPMainNavigationController alloc] initWithRootViewController:vc];
        root.tabBarItem = [[MainTabBarItem alloc] initWithTitle:nameArr[i] image:defaultImages[i] selectedImage:selectedImages[i] titleColor:defaultColor selectedTitleColor:selectedColor];
        [viewcontrollers addObject:root];
    }
    self.viewControllers = viewcontrollers;
}

@end
