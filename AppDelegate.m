//
//  AppDelegate.m
//  LearnWord
//
//  Created by famin on 2019/4/2.
//  Copyright © 2019年 english. All rights reserved.
//

#import "AppDelegate.h"
#import "LTPMainTabBarController.h"
#import <BmobSDK/Bmob.h>
#import <ZZMediator+ZZLogin.h>
#import <ZZMediator+ZZTranslate.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Bmob registerWithAppKey:@"bcfd40bb04764639c885eec5251936b6"];
    [[ZZMediator defaultZZMediator] trans_getTipsFromPlistFile];
    //
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    LTPMainTabBarController *root = [[LTPMainTabBarController alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kLTPWordsPhone]) {
        self.window.rootViewController = root;
    } else {
        self.window.rootViewController = [[ZZMediator defaultZZMediator] login_fetchLoginVC];
    }
    [self.window makeKeyAndVisible];
    
    // 15846985234
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 设置navigationbar
    [UINavigationBar appearance].barTintColor = [[ZZMediator defaultZZMediator] cat_colorWithHexString:@"0x44BB88"];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    return YES;
}

@end
