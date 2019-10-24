//
//  LTPRegisterTableViewController.m
//  PictureWords
//
//  Created by zhao on 2019/9/11.
//  Copyright © 2019 english. All rights reserved.
//

#import "LTPRegisterTableViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "LTPTimer.h"
#import "LTPPwdTableViewController.h"

@interface LTPRegisterTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *re_phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *re_codeTF;
@property (weak, nonatomic) IBOutlet UIButton *re_sendCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *re_registerBtn;



@end

@implementation LTPRegisterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.re_sendCodeBtn.layer.cornerRadius = 3.0;
    self.re_registerBtn.layer.cornerRadius = 5.0;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 离开界面 取消定时器
    [LTPTimer invalidate];
}


- (void)textFieldDidChange:(NSNotification *)noti
{
    if ([noti.object isEqual:self.re_phoneTF]) {
        self.re_phoneTF.text = (self.re_phoneTF.text.length > 11) ? [self.re_phoneTF.text substringToIndex:11] : self.re_phoneTF.text;
    }
    if ([noti.object isEqual:self.re_codeTF]) {
        self.re_codeTF.text = (self.re_codeTF.text.length > 4) ? [self.re_codeTF.text substringToIndex:4] : self.re_codeTF.text;
    }
}

#pragma mark -- IBAction

- (IBAction)ltp_clickSendCodeBtn:(id)sender
{
    if (![[ZZMediator defaultZZMediator] cat_checkPhone:self.re_phoneTF.text]) {
        [[ZZMediator defaultZZMediator] cat_showTextHudWithMeeage:@"请输入正确的手机号！" autoHide:2.0 view:self.view];
        return;
    }
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.re_phoneTF.text zone:@"86" result:^(NSError *error) {
        if (!error) {
            [[ZZMediator defaultZZMediator] cat_showTextHudWithMeeage:@"验证码发送成功!" autoHide:2.0 view:self.view];
            [LTPTimer startTimerWithKey:@"Register" andTimeBtn:self.re_sendCodeBtn];
        }
        else {
            [[ZZMediator defaultZZMediator] cat_showTextHudWithMeeage:@"网络出错，请检查网络后重试!" autoHide:2.0 view:self.view];
        }
    }];
}


- (IBAction)ltp_clickRegisterBtn:(UIButton *)sender
{
    if (![[ZZMediator defaultZZMediator] cat_checkPhone:self.re_phoneTF.text]) {
        [[ZZMediator defaultZZMediator] cat_showTextHudWithMeeage:@"请输入正确的手机号！" autoHide:2.0 view:self.view];
        return;
    }
    if (self.re_codeTF.text.length < 3) {
        [[ZZMediator defaultZZMediator] cat_showTextHudWithMeeage:@"请输入正确格式的验证码！" autoHide:2.0 view:self.view];
        return;
    }

    [[ZZMediator defaultZZMediator] cat_showIndicatorHUDWithMessage:@"" view:self.view];
    [SMSSDK commitVerificationCode:self.re_codeTF.text phoneNumber:self.re_phoneTF.text zone:@"86" result:^(NSError *error) {
        [[ZZMediator defaultZZMediator] cat_hideIndicatorHUD:self.view];
        if (!error) {
            // 验证成功
            [[NSUserDefaults standardUserDefaults] setObject:self.re_phoneTF.text forKey:kLTPWordsPhone];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            LTPPwdTableViewController *pwd = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LTPPwdTableViewController"];
            pwd.isReset = NO;
            pwd.phone = self.re_phoneTF.text;
            [self.navigationController pushViewController:pwd animated:YES];
        }
        else {
            [[ZZMediator defaultZZMediator] cat_showTextHudWithMeeage:@"验证码错误，请重试！" autoHide:2.0 view:self.view];
        }
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.re_codeTF resignFirstResponder];
    [self.re_phoneTF resignFirstResponder];
}

@end
