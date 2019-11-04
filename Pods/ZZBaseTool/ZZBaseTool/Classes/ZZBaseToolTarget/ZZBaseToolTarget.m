//
//  ZZBaseToolTarget.m
//  PictureWords
//
//  Created by zhao on 2019/10/17.
//  Copyright © 2019 english. All rights reserved.
//

#import "ZZBaseToolTarget.h"
#import "UIColor+LTPColor.h"
#import "NSString+LTPCheck.h"
#import "PPNetworkHandle.h"
#import "UIImage+LTPOrien.h"
#import "LTPHUDManager.h"
#import "ClipImageView.h"
#import "LTPTextView.h"

@implementation ZZBaseToolTarget

#pragma mark -- categary

- (UIColor *)bt_colorWithHex:(NSDictionary *)params
{
    return [UIColor ltp_colorWithHexString:params[@"hexString"]];
}

- (BOOL)bt_checkPhone:(NSDictionary *)params
{
    return [NSString ltp_checkTelNumber:params[@"phone"]];
}

- (BOOL)bt_checkPwd:(NSDictionary *)params
{
    return [NSString ltp_checkPassword:params[@"pwd"]];
}


- (UIImage *)bt_fixImageOrientation:(NSDictionary *)params
{
    return [params[@"image"] ltp_fixOrientation];
}

- (UIImage *)bt_getImageWithName:(NSDictionary *)params
{
    return [UIImage ltp_imageWithName:params[@"imageName"] atClass:params[@"class"] bundlenName:params[@"bundleName"]];
}


- (void)bt_showIndicatorHUD:(NSDictionary *)params
{
    [LTPHUDManager ltp_showActivityIndicatorViewWithMessage:params[@"message"] view:params[@"curView"]];
}

- (void)bt_hiddenIndicatorHUD:(NSDictionary *)params
{
    [LTPHUDManager ltp_hiddenActivityIndicatorFromView:params[@"curView"]];
}

- (void)bt_showTextHud:(NSDictionary *)params
{
    [LTPHUDManager ltp_showNormalHudWithMessage:params[@"message"] autoHiddenAfterTime:[params[@"after"] floatValue] view:params[@"curView"]];
}

#pragma mark -- ClipAvator

- (ClipImageView *)bt_initClipAvatorView:(NSDictionary *)params
{
    ClipImageView *clipView = [ClipImageView initWithFrame:CGRectFromString(params[@"frame"])];
    clipView.clipType = [params[@"type"] integerValue];
    clipView.clipImage = params[@"clipImage"];
    clipView.midLineColor = params[@"midLineColor"];
    return clipView;
}

- (UIImage *)bt_getClipedImage:(NSDictionary *)params
{
    UIImage *image = nil;
    if ([params[@"clipView"] isKindOfClass:[ClipImageView class]]) {
        image = [(ClipImageView *)params[@"clipView"] getClipedImage];
    }
    return image;
}


#pragma mark -- NetworkHandle

typedef void(^NetworkSuccessBlock)(id responeData);
typedef void(^NetworkFailureBlock)(NSError *error);

- (void)bt_getRequestWithParams:(NSDictionary *)params
{
    NetworkSuccessBlock success = params[@"NetworkSuccessBlock"];
    NetworkFailureBlock failure = params[@"NetworkFailureBlock"];
    
    [PPNetworkHandle ltp_GET:params[@"url"] parameters:params[@"params"] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responeData) {
        if (success) {
            success(responeData);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)bt_postRequestWithParams:(NSDictionary *)params
{
    NetworkSuccessBlock success = params[@"SuccessBlock"];
    NetworkFailureBlock failure = params[@"FailureBlock"];
    
    [PPNetworkHandle ltp_POST:params[@"url"] parameters:params[@"params"] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responeData) {
        if (success) {
            success(success);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark -- ZZCustomView

- (LTPTextView *)bt_getCustomTextView:(NSDictionary *)params
{
    LTPTextView *cv = [[LTPTextView alloc] initWithFrame:CGRectFromString(params[@"frame"])];
    cv.ltp_systemFont = [params[@"font"] floatValue];
    cv.ltp_placeHolder = params[@"placeHolder"];
    return cv;
}

@end
