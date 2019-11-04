//
//  ZZMediator+ZZLearnWords.m
//  ZZLearnWords_Example
//
//  Created by zhao on 2019/10/31.
//  Copyright © 2019 zhaoName. All rights reserved.
//

#import "ZZMediator+ZZLearnWords.h"

@implementation ZZMediator (ZZLearnWords)

- (UIViewController *)learn_fetchHomeVC
{
    return [self zz_preformTagert:@"ZZLearnWordsTarget" action:@"lw_pwtFetchHomeVC" params:nil shouldCache:NO];
}

- (UIViewController *)learn_fetchCollectionVC
{
    return [self zz_preformTagert:@"ZZLearnWordsTarget" action:@"lw_fetchCollectionVC" params:nil shouldCache:NO];
}

@end
