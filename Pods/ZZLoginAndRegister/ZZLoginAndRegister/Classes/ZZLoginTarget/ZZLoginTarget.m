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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ZZLoginAndRegister" ofType:@"bundle"];
    NSBundle *bundle =  [NSBundle bundleWithPath:path];
    return [[UIStoryboard storyboardWithName:@"Login" bundle:bundle] instantiateInitialViewController];
}


@end
