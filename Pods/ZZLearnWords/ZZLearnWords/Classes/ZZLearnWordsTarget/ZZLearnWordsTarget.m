//
//  ZZLearnWordsTarget.m
//  PictureWords
//
//  Created by zhao on 2019/10/17.
//  Copyright © 2019 english. All rights reserved.
//

#import "ZZLearnWordsTarget.h"
#import "LTPHomeViewController.h"
#import "LTPCollectionViewController.h"

@implementation ZZLearnWordsTarget

- (LTPHomeViewController *)lw_pwtFetchHomeVC
{
    return [LTPHomeViewController new];
}

- (LTPHomeViewController *)lw_fetchCollectionVC
{
    return [LTPCollectionViewController new];
}

@end
