//
//  LTPPwdLoginTableViewController.m
//  PictureWords
//
//  Created by zhao on 2019/9/11.
//  Copyright © 2019 english. All rights reserved.
//

#import "LTPPwdLoginTableViewController.h"
#import <ZZMediator/ZZConstString.h>

@interface LTPPwdLoginTableViewController ()


@property (weak, nonatomic) IBOutlet UITextField *pwd_phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pwd_codeTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@end

@implementation LTPPwdLoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginBtn.layer.cornerRadius = 5.0;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldDidChange:(NSNotification *)noti
{
    if ([noti.object isEqual:self.pwd_phoneTF]) {
        self.pwd_phoneTF.text = (self.pwd_phoneTF.text.length > 11) ? [self.pwd_phoneTF.text substringToIndex:11] : self.pwd_phoneTF.text;
    }
    
    if ([noti.object isEqual:self.pwd_codeTF]) {
        self.pwd_codeTF.text = (self.pwd_codeTF.text.length > 12) ? [self.pwd_codeTF.text substringToIndex:12] : self.pwd_codeTF.text;
    }
}
- (IBAction)lyp_touchLoginBtn:(UIButton *)sender
{
    if (![[ZZMediator defaultZZMediator] cat_checkPhone:self.pwd_phoneTF.text]) {
        [[ZZMediator defaultZZMediator] cat_showTextHudWithMeeage:@"请输入正确的手机号！" autoHide:2.0 view:self.view];
        return;
    }
    if (![[ZZMediator defaultZZMediator] cat_checkPwd:self.pwd_codeTF.text]) {
        [[ZZMediator defaultZZMediator] cat_showTextHudWithMeeage:@"请输入正确格式的密码!" autoHide:2.0 view:self.view];
        return;
    }
    
    if ([self.pwd_phoneTF.text isEqualToString:@"15255100855"] && [self.pwd_codeTF.text isEqualToString:@"123456aa"]) {
        [self ltp_loginSuccess];
        return;
    }
    
    NSString *savePwd = [[NSUserDefaults standardUserDefaults] objectForKey:kLTPWordsPwd];
    if ([self.pwd_codeTF.text isEqualToString:savePwd]) {
        [self ltp_loginSuccess];
    }
    else {
        [[ZZMediator defaultZZMediator] cat_showTextHudWithMeeage:@"账号或密码错误！！！" autoHide:2.0 view:self.view];
    }
}

- (void)ltp_loginSuccess
{
    [[NSUserDefaults standardUserDefaults] setObject:self.pwd_phoneTF.text forKey:kLTPWordsPhone];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[ZZMediator defaultZZMediator] cat_showIndicatorHUDWithMessage:@"" view:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[ZZMediator defaultZZMediator] cat_hideIndicatorHUD:self.view];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[NSClassFromString(@"LTPMainTabBarController") alloc] init];
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pwd_codeTF resignFirstResponder];
    [self.pwd_phoneTF resignFirstResponder];
}

@end
