//
//  ZZMediator+ZZLogin.m
//  PictureWords
//
//  Created by zhao on 2019/10/21.
//  Copyright © 2019 english. All rights reserved.
//

#import "ZZMediator+ZZLogin.h"

@implementation ZZMediator (ZZLogin)

- (UIViewController *)login_fetchLoginVC
{
    return [self zz_preformTagert:@"ZZLoginTarget" action:@"lr_fetchLoginVC" params:@{} shouldCache:NO];
}


@end
