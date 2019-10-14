//
//  NSString+LTPCheck.m
//  PictureWords
//
//  Created by zhao on 2019/9/11.
//  Copyright © 2019 english. All rights reserved.
//

#import "NSString+LTPCheck.h"

@implementation NSString (LTPCheck)


/// 正则匹配手机号
+ (BOOL)ltp_checkTelNumber:(NSString*)telNumber
{
    NSString*pattern =@"^1+[3578]+\\d{9}";
    NSPredicate*pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}


/// 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)ltp_checkPassword:(NSString*)password
{
    NSString*pattern =@"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,12}";
    NSPredicate*pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

@end
