//
//  LTPMainTabBarController.m
//  LearnWord
//
//  Created by famin on 2019/4/4.
//  Copyright © 2019年 english. All rights reserved.
//

#import "LTPMainTabBarController.h"
#import <ZZMediator+ZZLearnWords.h>
#import <ZZMediator+ZZSettings.h>
#import <ZZMediator+ZZTranslate.h>

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
    NSArray *vcClassArr = @[
                                   [[ZZMediator defaultZZMediator] learn_fetchHomeVC],
                                   [[ZZMediator defaultZZMediator] trans_fetchTranslateVC],
                                   [[ZZMediator defaultZZMediator] settings_fetchSettingsVC],
                                   //[LTPProgressViewController class]
                                   ];
    UIColor *defaultColor = [[ZZMediator defaultZZMediator] cat_colorWithHexString:@"0xbfbfbf"];
    UIColor *selectedColor = [[ZZMediator defaultZZMediator] cat_colorWithHexString:@"0x44BB88"];
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
        UINavigationController *root = [[UINavigationController alloc] initWithRootViewController:vcClassArr[i]];
        root.tabBarItem = [[MainTabBarItem alloc] initWithTitle:nameArr[i] image:defaultImages[i] selectedImage:selectedImages[i] titleColor:defaultColor selectedTitleColor:selectedColor];
        [viewcontrollers addObject:root];
    }
    self.viewControllers = viewcontrollers;
}

@end
