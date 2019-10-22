//
//  ZZLoginTarget.m
//  PictureWords
//
//  Created by zhao on 2019/10/21.
//  Copyright © 2019 english. All rights reserved.
//

#import "ZZLoginTarget.h"
#import "LTPPwdLoginTableViewController.h"

@implementation ZZLoginTarget

- (LTPPwdLoginTableViewController *)lr_fetchLoginVC
{
    return [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
}


@end
