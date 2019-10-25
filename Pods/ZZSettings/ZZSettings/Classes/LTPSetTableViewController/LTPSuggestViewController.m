//
//  LTPSuggestViewController.m
//  PictureWords
//
//  Created by zhao on 2019/9/12.
//  Copyright © 2019 english. All rights reserved.
//

#import "LTPSuggestViewController.h"
#import <ZZMediator/ZZMediator+ZZBaseTool.h>

#define Settings_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface LTPSuggestViewController ()

@property (strong, nonatomic) UITextView *suggestTextView;

@end

@implementation LTPSuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"改进意见";
    self.view.backgroundColor = [[ZZMediator defaultZZMediator] cat_colorWithHexString:@"0xf4f7f9"];
    
    self.suggestTextView = [[ZZMediator defaultZZMediator] cat_fetchCustomTextView:CGRectMake(25, 120, Settings_SCREEN_WIDTH - 50, 200) font:16 placeHolder:@"请输入您要反馈的内容...若您不介意做好留下您的联系方式，谢谢！"];
    [self.view addSubview:self.suggestTextView];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(commitSuggestToUs:)];
}

- (void)commitSuggestToUs:(UIBarButtonItem *)sender
{
    if (self.suggestTextView.text.length == 0)  {
        [[ZZMediator defaultZZMediator] cat_showTextHudWithMeeage:@"亲,您还未给出您的宝贵意见哦~" autoHide:2.0 view:self.view];
        return;
    }
    
    [[ZZMediator defaultZZMediator] cat_showIndicatorHUDWithMessage:@"提交中..." view:self.view];
    [self.suggestTextView resignFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[ZZMediator defaultZZMediator] cat_hideIndicatorHUD:self.view];
        [[ZZMediator defaultZZMediator] cat_showTextHudWithMeeage:@"谢谢您的宝贵建议！" autoHide:2.0 view:self.view];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
