//
//  LTPInfoTableViewController.m
//  PictureWords
//
//  Created by zhao on 2019/9/11.
//  Copyright © 2019 english. All rights reserved.
//

#import "LTPInfoTableViewController.h"
#import "LTPClipAvaterViewController.h"
#import "LTPMainTabBarController.h"

@interface LTPInfoTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, LTPClipAvaterViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *avaterBtn;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;


@end

@implementation LTPInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人信息";
    self.finishBtn.layer.cornerRadius = 5.0;
    self.avaterBtn.layer.cornerRadius = 75;
    self.avaterBtn.clipsToBounds = YES;
}


- (IBAction)ltp_touchSetAvaterBtn:(UIButton *)sender
{
    [self openCameraOrPhotoLibrary];
}


- (IBAction)ltp_clickFinishBtn:(UIButton *)sender
{
    if (self.nickNameTF.text.length == 0) {
        [[ZZMediator defaultZZMediator] cat_showTextHudWithMeeage:@"请设置昵称..." autoHide:2.0 view:self.view];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.nickNameTF.text forKey:kLTPWordsNickName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[LTPMainTabBarController alloc] init];
}

#pragma mark -- 打开相机或相册

- (void)openCameraOrPhotoLibrary
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 打开相机 比较懒，暂时先这样获取访问权限
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [self openWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 打开相册
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            [self openWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
}

//
- (void)openWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.sourceType = sourceType;
    imagePickerVC.delegate = self;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    LTPClipAvaterViewController *clipAvatarVC = [[LTPClipAvaterViewController alloc] init];
    clipAvatarVC.delegate = self;
    clipAvatarVC.needClipImage = [[ZZMediator defaultZZMediator] cat_getImageFixOrientation:info[UIImagePickerControllerOriginalImage]];
    [picker pushViewController:clipAvatarVC animated:YES];
}

#pragma mark  -- ClipAvatarViewControllerDelegate
// 获取裁剪后的图片
- (void)didSuccessClipImage:(UIImage *)clipedImage
{
    if (clipedImage) {
        [self.avaterBtn setBackgroundImage:clipedImage forState:UIControlStateNormal];
        [self.avaterBtn setTitle:@"" forState:UIControlStateNormal];
        self.avaterBtn.backgroundColor = [UIColor whiteColor];
        
        // 保存图片到本地
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        path = [path stringByAppendingPathComponent:@"avater.png"];
        [UIImagePNGRepresentation(clipedImage) writeToFile:path atomically:YES];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.nickNameTF resignFirstResponder];
}

@end
