//
//  NSString+LTPCheck.h
//  PictureWords
//
//  Created by zhao on 2019/9/11.
//  Copyright © 2019 english. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LTPCheck)

/// 正则匹配手机号
+ (BOOL)ltp_checkTelNumber:(NSString*)telNumber;
/// 正则匹配用户密码6-18位数字和字母组合
+ (BOOL)ltp_checkPassword:(NSString*)password;

@end

NS_ASSUME_NONNULL_END
