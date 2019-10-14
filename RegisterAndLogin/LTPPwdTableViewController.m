//
//  LTPPwdTableViewController.m
//  PictureWords
//
//  Created by zhao on 2019/9/11.
//  Copyright © 2019 english. All rights reserved.
//

#import "LTPPwdTableViewController.h"
#import "NSString+LTPCheck.h"
#import "LTPMainTabBarController.h"
#import "LTPInfoTableViewController.h"

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
    if (![NSString ltp_checkPassword:self.pwdTF.text]) {
        [self ltp_showNormalHudWithMessage:@"请输入正确格式的密码！" autoHiddenAfterTime:2.0];
        return;
    }
    if (![self.confirmPwdTF.text isEqualToString:self.pwdTF.text]) {
        [self ltp_showNormalHudWithMessage:@"两次输入的密码不一样" autoHiddenAfterTime:2.0];
        return;
    }

    [self ltp_showNormalHudWithMessage:self.isReset ? @"重置成功" : @"登录成功！" autoHiddenAfterTime:2.0];
    [[NSUserDefaults standardUserDefaults] setObject:self.phone forKey:kLTPWordsPhone];
    [[NSUserDefaults standardUserDefaults] setObject:self.pwdTF.text forKey:kLTPWordsPwd];
    [[NSUserDefaults standardUserDefaults] synchronize];

    if(self.isReset) {
        [UIApplication sharedApplication].keyWindow.rootViewController = [[LTPMainTabBarController alloc] init];
    }
    else {
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
        [UIApplication sharedApplication].keyWindow.rootViewController = [[LTPMainTabBarController alloc] init];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pwdTF resignFirstResponder];
    [self.confirmPwdTF resignFirstResponder];
}

@end
