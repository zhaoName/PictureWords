//
//  LTPClipAvaterViewController.m
//  PictureWords
//
//  Created by zhao on 2019/9/11.
//  Copyright © 2019 english. All rights reserved.
//

#import "LTPClipAvaterViewController.h"
#import "ClipImageView.h"
#import "UIColor+LTPColor.h"

@interface LTPClipAvaterViewController ()

@property (nonatomic, strong) ClipImageView *clipImageView; /**< 需要裁剪的图片*/

@end

@implementation LTPClipAvaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title =  @"头像裁剪";
    self.clipImageView.clipImage = self.needClipImage;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.clipImageView];
    
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
    UIImage *clipedImage = [self.clipImageView getClipedImage];
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

- (ClipImageView *)clipImageView
{
    if(!_clipImageView)
    {
        _clipImageView = [ClipImageView initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 400)];
        _clipImageView.midLineColor = [UIColor ltp_mainRedColor];
        _clipImageView.clipType = ClipAreaViewTypeRect;
    }
    return _clipImageView;
}



@end
