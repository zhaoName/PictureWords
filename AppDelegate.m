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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Bmob registerWithAppKey:@"bcfd40bb04764639c885eec5251936b6"];
    [self ltp_saveTipsToDocumentPath];
    //
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    LTPMainTabBarController *root = [[LTPMainTabBarController alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kLTPWordsPhone]) {
        self.window.rootViewController = root;
    } else {
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
    }
    [self.window makeKeyAndVisible];
    
    // 15846985234
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    return YES;
}


#pragma mark -- private method

- (void)ltp_saveTipsToDocumentPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"PPHistory.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) return;
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PPTips" ofType:@".plist"]];
    [arr writeToFile:path atomically:YES];
}

@end
