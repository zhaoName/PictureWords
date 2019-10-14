//
//  LTPCodeLoginTableViewController.m
//  PictureWords
//
//  Created by zhao on 2019/9/11.
//  Copyright © 2019 english. All rights reserved.
//

#import "LTPCodeLoginTableViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "LTPTimer.h"
#import "LTPPwdTableViewController.h"
#import "NSString+LTPCheck.h"

@interface LTPCodeLoginTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *code_PhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *code_codeTF;
@property (weak, nonatomic) IBOutlet UIButton *code_sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *code_LoginBtn;

@end

@implementation LTPCodeLoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.code_sendBtn.layer.cornerRadius = 3.0;
    self.code_LoginBtn.layer.cornerRadius = 5.0;
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
    if ([noti.object isEqual:self.code_PhoneTF]) {
        self.code_PhoneTF.text = (self.code_PhoneTF.text.length > 11) ? [self.code_PhoneTF.text substringToIndex:11] : self.code_PhoneTF.text;
    }
    if ([noti.object isEqual:self.code_codeTF]) {
        self.code_codeTF.text = (self.code_codeTF.text.length > 4) ? [self.code_codeTF.text substringToIndex:4] : self.code_codeTF.text;
    }
}

#pragma mark -- IBAction

- (IBAction)ltp_touchSendCodeBtn:(id)sender
{
    if (![NSString ltp_checkTelNumber:self.code_PhoneTF.text]) {
        [self ltp_showNormalHudWithMessage:@"请输入正确的手机号！" autoHiddenAfterTime:2.0];
        return;
    }
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.code_PhoneTF.text zone:@"86" result:^(NSError *error) {
        if (!error) {
            [self ltp_showNormalHudWithMessage:@"验证码发送成功!" autoHiddenAfterTime:2.0];
            [LTPTimer startTimerWithKey:@"Register" andTimeBtn:self.code_sendBtn];
        }
        else {
            [self ltp_showNormalHudWithMessage:@"网络出错，请检查网络后重试!" autoHiddenAfterTime:2.0];
        }
    }];
}

- (IBAction)ltp_touchCodeLoginBtn:(id)sender
{
    if (![NSString ltp_checkTelNumber:self.code_PhoneTF.text]) {
        [self ltp_showNormalHudWithMessage:@"请输入正确的手机号！" autoHiddenAfterTime:2.0];
        return;
    }
    if (self.code_codeTF.text.length < 3) {
        [self ltp_showNormalHudWithMessage:@"请输入正确格式的验证码！" autoHiddenAfterTime:2.0];
        return;
    }
    
    [self ltp_showActivityIndicatorViewWithMessage:@""];
    [SMSSDK commitVerificationCode:self.code_codeTF.text phoneNumber:self.code_PhoneTF.text zone:@"86" result:^(NSError *error) {
        [self ltp_hiddenActivityIndicatorView];
        if (!error) {
            // 验证成功
            [[NSUserDefaults standardUserDefaults] setObject:self.code_PhoneTF.text forKey:kLTPWordsPhone];
            [[NSUserDefaults standardUserDefaults] synchronize];
            LTPPwdTableViewController *pwd = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LTPPwdTableViewController"];
            pwd.isReset = YES;
            pwd.phone = self.code_PhoneTF.text;
            [self.navigationController pushViewController:pwd animated:nil];
        }
        else {
            [self ltp_showNormalHudWithMessage:@"验证码错误，请重试！" autoHiddenAfterTime:2.0];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.code_codeTF resignFirstResponder];
    [self.code_PhoneTF resignFirstResponder];
}


@end
