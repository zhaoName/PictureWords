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
#import "NSString+LTPCheck.h"
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
    if (![NSString ltp_checkTelNumber:self.re_phoneTF.text]) {
        [self ltp_showNormalHudWithMessage:@"请输入正确的手机号！" autoHiddenAfterTime:2.0];
        return;
    }
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.re_phoneTF.text zone:@"86" result:^(NSError *error) {
        if (!error) {
            [self ltp_showNormalHudWithMessage:@"验证码发送成功!" autoHiddenAfterTime:2.0];
            [LTPTimer startTimerWithKey:@"Register" andTimeBtn:self.re_sendCodeBtn];
        }
        else {
            [self ltp_showNormalHudWithMessage:@"网络出错，请检查网络后重试!" autoHiddenAfterTime:2.0];
        }
    }];
}


- (IBAction)ltp_clickRegisterBtn:(UIButton *)sender
{
    if (![NSString ltp_checkTelNumber:self.re_phoneTF.text]) {
        [self ltp_showNormalHudWithMessage:@"请输入正确的手机号！" autoHiddenAfterTime:2.0];
        return;
    }
    if (self.re_codeTF.text.length < 3) {
        [self ltp_showNormalHudWithMessage:@"请输入正确格式的验证码！" autoHiddenAfterTime:2.0];
        return;
    }

    [self ltp_showActivityIndicatorViewWithMessage:@""];
    [SMSSDK commitVerificationCode:self.re_codeTF.text phoneNumber:self.re_phoneTF.text zone:@"86" result:^(NSError *error) {
        [self ltp_hiddenActivityIndicatorView];
        if (!error) {
            // 验证成功
            [[NSUserDefaults standardUserDefaults] setObject:self.re_phoneTF.text forKey:kLTPWordsPhone];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            LTPPwdTableViewController *pwd = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LTPPwdTableViewController"];
            pwd.isReset = NO;
            pwd.phone = self.re_phoneTF.text;
            [self.navigationController pushViewController:pwd animated:nil];
        }
        else {
            [self ltp_showNormalHudWithMessage:@"验证码错误，请重试！" autoHiddenAfterTime:2.0];
        }
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.re_codeTF resignFirstResponder];
    [self.re_phoneTF resignFirstResponder];
}

@end
