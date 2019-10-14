//
//  UIColor+Add.h
//  Account
//
//  Created by zhao on 2017/8/30.
//  Copyright © 2017年 chuangqish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LTPColor)

/**
 * 主色调 0x44bb88
 */
+ (UIColor *)ltp_mainRedColor;

/**
 * 点缀色 0x1fbba6
 */
+ (UIColor *)ltp_embellishLightBlueColor;

/**
 * 背景色 0xfafcfd
 */
+ (UIColor *)ltp_BGFAFCFDColor;

/**
 * 背景色 0xcccccc
 */
+ (UIColor *)ltp_BGCCCCCCColor;

/**
 由传过来的16进制 生成对应颜色

 @param hexColorString 16进制值 以0x 或 #开头
 @return 颜色
 */
+ (UIColor *)ltp_colorWithHexString:(NSString *)hexColorString;

/**
 由传过来的16进制 生成对应颜色

 @param hexColorString 16进制值 以0x 或 #开头
 @param alpha 透明度
 @return 颜色
 */
+ (UIColor *)ltp_colorWithHexString:(NSString *)hexColorString alpha:(CGFloat)alpha;

@end
