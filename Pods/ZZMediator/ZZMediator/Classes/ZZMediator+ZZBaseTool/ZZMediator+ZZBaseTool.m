//
//  ZZMediator+ZZBaseTool.m
//  PictureWords
//
//  Created by zhao on 2019/10/17.
//  Copyright © 2019 english. All rights reserved.
//

#import "ZZMediator+ZZBaseTool.h"

@implementation ZZMediator (ZZBaseTool)

#pragma mark -- categary

- (UIColor *)cat_colorWithHexString:(NSString *)hexString
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:hexString forKey:@"hexString"];
    return [self zz_preformTagert:@"ZZBaseToolTarget" action:@"bt_colorWithHex:" params:params shouldCache:NO];
}

- (BOOL)cat_checkPhone:(NSString *)phone
{
    return [[self zz_preformTagert:@"ZZBaseToolTarget" action:@"bt_checkPhone:" params:@{@"phone":phone} shouldCache:NO] boolValue];
}

- (BOOL)cat_checkPwd:(NSString *)pwd
{
    id result = [self zz_preformTagert:@"ZZBaseToolTarget" action:@"bt_checkPwd:" params:@{@"pwd":pwd} shouldCache:NO];
    return [result boolValue];
}

- (UIImage *)cat_getImageFixOrientation:(UIImage *)image
{
    return [self zz_preformTagert:@"ZZBaseToolTarget" action:@"bt_fixImageOrientation:" params:@{@"image":image} shouldCache:NO];
}

- (UIImage *)cat_imageWithName:(NSString *)imageName atClass:(Class)cls bundleName:(NSString *)bundleName
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:imageName forKey:@"imageName"];
    [params setValue:(cls ? cls : UIImage.class) forKey:@"class"];
    [params setValue:(bundleName.length ? bundleName : @"") forKey:@"bundleName"];
    return [self zz_preformTagert:@"ZZBaseToolTarget" action:@"bt_getImageWithName:" params:params shouldCache:NO];
}


- (void)cat_showIndicatorHUDWithMessage:(NSString *)message view:(UIView *)curView
{
    if (curView == nil) {
        curView = [UIApplication sharedApplication].keyWindow;
    }
    [self zz_preformTagert:@"ZZBaseToolTarget" action:@"bt_showIndicatorHUD:" params:@{@"message":message, @"curView":curView} shouldCache:NO];
}

- (void)cat_hideIndicatorHUD:(UIView *)curView
{
    if (curView == nil) {
        curView = [UIApplication sharedApplication].keyWindow;
    }
    [self zz_preformTagert:@"ZZBaseToolTarget" action:@"bt_hiddenIndicatorHUD:" params:@{@"curView":curView} shouldCache:NO];
}

- (void)cat_showTextHudWithMeeage:(NSString *)message autoHide:(CGFloat)after view:(UIView *)curView
{
    if (curView == nil) {
        curView = [UIApplication sharedApplication].keyWindow;
    }
    [self zz_preformTagert:@"ZZBaseToolTarget" action:@"bt_showTextHud:" params:@{@"message":message, @"after":@(after), @"curView":curView} shouldCache:NO];
}


#pragma mark -- ClipAvator

- (UIView *)cat_initClipView:(CGRect)frame type:(NSInteger)type image:(nonnull UIImage *)image midLineColor:(nonnull UIColor *)lineColor
{
    NSDictionary *params = @{@"frame":NSStringFromCGRect(frame), @"type":@(type), @"clipImage":image, @"midLineColor":lineColor};
    return [self zz_preformTagert:@"ZZBaseToolTarget" action:@"bt_initClipAvatorView:" params:params shouldCache:YES];
}

- (UIImage *)cat_clipedImage:(UIView *)clipView
{
    return [self zz_preformTagert:@"ZZBaseToolTarget" action:@"bt_getClipedImage:" params:@{@"clipView":clipView} shouldCache:YES];
}

#pragma mark -- NetworkHandle

- (void)cat_getRequestWithUrl:(NSString *)urlString params:(NSDictionary *)params success:(void(^)(id responeData))success failure:(void(^)(NSError *error))failure
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:urlString forKey:@"url"];
    [paramDict setValue:params forKey:@"params"];
    [paramDict setValue:success forKey:@"NetworkSuccessBlock"];
    [paramDict setValue:failure forKey:@"NetworkFailureBlock"];
    
    [self zz_preformTagert:@"ZZBaseToolTarget" action:@"bt_getRequestWithParams:" params:paramDict shouldCache:NO];
}


- (void)cat_postRequestWithUrl:(NSString *)urlString params:(NSDictionary *)params success:(void(^)(id responeData))success failure:(void(^)(NSError *error))failure
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setValue:urlString forKey:@"url"];
    [paramDict setValue:params forKey:@"params"];
    [paramDict setValue:success forKey:@"NetworkSuccessBlock"];
    [paramDict setValue:failure forKey:@"NetworkFailureBlock"];
    
    [self zz_preformTagert:@"ZZBaseToolTarget" action:@"bt_postRequestWithParams:" params:paramDict shouldCache:NO];
}

#pragma mark -- ZZCustomView

- (UITextView *)cat_fetchCustomTextView:(CGRect)frame font:(CGFloat)font placeHolder:(NSString *)placeHolder
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:NSStringFromCGRect(frame) forKey:@"frame"];
    [params setValue:@(font) forKey:@"font"];
    [params setValue:placeHolder forKey:@"placeHolder"];
    return [self zz_preformTagert:@"ZZBaseToolTarget" action:@"bt_getCustomTextView:" params:params shouldCache:NO];
}


@end
