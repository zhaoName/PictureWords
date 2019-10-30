//
//  ZZMediator+ZZTranslate.m
//  ZZTranslate_Example
//
//  Created by zhao on 2019/10/29.
//  Copyright © 2019 zhaoName. All rights reserved.
//

#import "ZZMediator+ZZTranslate.h"

@implementation ZZMediator (ZZTranslate)

- (UIViewController *)trans_fetchTranslateVC
{
    return [self zz_preformTagert:@"ZZTranslateTarget" action:@"tt_fetchTranslateVC" params:@{} shouldCache:NO];
}

- (void)trans_getTipsFromPlistFile
{
    [self zz_preformTagert:@"ZZTranslateTarget" action:@"tt_getTipsFromPlistFile" params:nil shouldCache:NO];
}

@end
