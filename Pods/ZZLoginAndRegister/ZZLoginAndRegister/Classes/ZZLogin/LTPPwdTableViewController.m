//
//  LTPPwdTableViewController.m
//  PictureWords
//
//  Created by zhao on 2019/9/11.
//  Copyright © 2019 english. All rights reserved.
//

#import "LTPPwdTableViewController.h"
#import "LTPInfoTableViewController.h"
#import <ZZMediator/ZZConstString.h>

@interface LTPPwdTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTF;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;


@end

@implementation LTPPwdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.isReset ? @"重置密码" : @"设置密码";
}


- (IBAction)ltp_touchFinishBtn:(UIButton *)sender
{
    if (![[ZZMediator defaultZZMediator] cat_checkPwd:self.pwdTF.text]) {
        [[ZZMediator defaultZZMediator] cat_showTextHudWithMeeage:@"请输入正确格式的密码！" autoHide:2.0 view:self.view];
        return;
    }
    if (![self.confirmPwdTF.text isEqualToString:self.pwdTF.text]) {
        [[ZZMediator defaultZZMediator] cat_showTextHudWithMeeage:@"两次输入的密码不一样" autoHide:2.0 view:self.view];
        return;
    }

    [[ZZMediator defaultZZMediator] cat_showTextHudWithMeeage:self.isReset ? @"重置成功" : @"登录成功！" autoHide:2.0 view:self.view];
    [[NSUserDefaults standardUserDefaults] setObject:self.phone forKey:kLTPWordsPhone];
    [[NSUserDefaults standardUserDefaults] setObject:self.pwdTF.text forKey:kLTPWordsPwd];
    [[NSUserDefaults standardUserDefaults] synchronize];

    if(self.isReset) {
        // 重置成功 跳转到登录页
        [UIApplication sharedApplication].keyWindow.rootViewController = [[NSClassFromString(@"LTPPwdLoginTableViewController") alloc] init];
    }
    else {
        // 设置密码成功 提示用户去设置个人信息
        [self ltp_suggestUserToSeting];
    }
}

- (void)ltp_suggestUserToSeting
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜" message:@"注册成功！现在要去设置个人信息吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LTPInfoTableViewController *info = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LTPInfoTableViewController"];
        [self.navigationController pushViewController:info animated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"跳过" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [UIApplication sharedApplication].keyWindow.rootViewController = [[NSClassFromString(@"LTPMainTabBarController") alloc] init];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pwdTF resignFirstResponder];
    [self.confirmPwdTF resignFirstResponder];
}

@end
