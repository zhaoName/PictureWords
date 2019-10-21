//
//  ZZMediator+PictureWords.m
//  PictureWords
//
//  Created by zhao on 2019/10/17.
//  Copyright © 2019 english. All rights reserved.
//

#import "ZZMediator+PictureWords.h"

@implementation ZZMediator (PictureWords)

- (UIViewController *)zz_fectchHomeVC
{
    return [self zz_preformTagert:@"ZZPictureWordsTarget" action:@"zz_pwtFetchHomeVC" params:@{} shouldCache:NO];
}


- (UIColor *)color:(NSString *)colorHex
{
    return [self zz_preformTagert:@"ZZPictureWordsTarget" action:@"zz_mainColor" params:@{} shouldCache:NO];
}

@end
