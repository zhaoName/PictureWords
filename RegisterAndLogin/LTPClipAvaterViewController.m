//
//  LTPClipAvaterViewController.m
//  PictureWords
//
//  Created by zhao on 2019/9/11.
//  Copyright © 2019 english. All rights reserved.
//

#import "LTPClipAvaterViewController.h"

@interface LTPClipAvaterViewController ()

@property (nonatomic, strong) UIView *avatorView;/**< */

@end

@implementation LTPClipAvaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title =  @"头像裁剪";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIColor *lineColor = [[ZZMediator defaultZZMediator] cat_colorWithHexString:@"0x44BB88"];
    self.avatorView = [[ZZMediator defaultZZMediator] cat_initClipView:CGRectMake(0, 80, SCREEN_WIDTH, 400) type:0 image:self.needClipImage midLineColor:lineColor];
    [self.view addSubview:self.avatorView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClipImage:)];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(successClipImage:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 从相机界面跳转会默认隐藏导航栏
    self.navigationController.navigationBarHidden = NO;
}

// 裁剪成功
- (void)successClipImage:(UIBarButtonItem *)sender
{
    UIImage *clipedImage = [[ZZMediator defaultZZMediator] cat_clipedImage:self.avatorView];
    if([self.delegate respondsToSelector:@selector(didSuccessClipImage:)]) {
        [self.delegate didSuccessClipImage:clipedImage];
    }
}

// 取消裁剪
- (void)cancelClipImage:(UIBarButtonItem *)sender
{
    if([self.delegate respondsToSelector:@selector(didSuccessClipImage:)]) {
        [self.delegate didSuccessClipImage:nil];
    }
}

#pragma mark -- getter


@end
