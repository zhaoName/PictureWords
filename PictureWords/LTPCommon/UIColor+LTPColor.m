//
//  UIColor+Add.m
//  Account
//
//  Created by zhao on 2017/8/30.
//  Copyright © 2017年 chuangqish. All rights reserved.
//

#import "UIColor+LTPColor.h"

@implementation UIColor (LTPColor)

/// 0x44bb88
+ (UIColor *)ltp_mainRedColor
{
    UIColor *resultColor = nil;
    if (@available(iOS 13.0, *)) {
         resultColor =  [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return UIColor.redColor;
            } else {
                return [self ltp_colorWithHexString:@"0x44BB88"];
            }
         }];
    } else {
        resultColor = [self ltp_colorWithHexString:@"0x44BB88"];
    }
    return resultColor;
}

+ (UIColor *)ltp_embellishLightBlueColor
{
    return [self ltp_colorWithHexString:@"0x1fbba6"];
}

+ (UIColor *)ltp_BGFAFCFDColor
{
    
    return [self ltp_colorWithHexString:@"0xfafcfd"];
}

+ (UIColor *)ltp_BGCCCCCCColor
{
    return [self ltp_colorWithHexString:@"0xcccccc"];
}

+ (UIColor *)ltp_colorWithHexString:(NSString *)hexColorString
{
    return [self ltp_colorWithHexString:hexColorString alpha:1.0];
}

+ (UIColor *)ltp_colorWithHexString:(NSString *)hexColorString alpha:(CGFloat)alpha
{
    if ([hexColorString length] < 6) { //长度不合法
        return [UIColor blackColor];
    }
    NSString *tempString = [hexColorString lowercaseString];
    if ([tempString hasPrefix:@"0x"]) { //检查开头是0x
        tempString = [tempString substringFromIndex:2];
    } else if ([tempString hasPrefix:@"#"]) { //检查开头是#
        tempString = [tempString substringFromIndex:1];
    }
    if ([tempString length] != 6) {
        return [UIColor blackColor];
    }
    //分解三种颜色的值
    NSRange range = NSMakeRange(0, 2);
    NSString *rString = [tempString substringWithRange:range];
    range.location = 2;
    NSString *gString = [tempString substringWithRange:range];
    range.location = 4;
    NSString *bString = [tempString substringWithRange:range];
    //取三种颜色值
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

@end
