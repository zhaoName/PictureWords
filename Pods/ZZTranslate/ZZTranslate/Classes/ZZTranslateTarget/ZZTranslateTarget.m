//
//  ZZTranslateTarget.m
//  PictureWords
//
//  Created by zhao on 2019/10/28.
//  Copyright © 2019 english. All rights reserved.
//

#import "ZZTranslateTarget.h"
#import "PPTranslateViewController.h"

@implementation ZZTranslateTarget

- (PPTranslateViewController *)tt_fetchTranslateVC
{
    return [[PPTranslateViewController alloc] init];
}


- (void)tt_getTipsFromPlistFile
{
    [PPTranslateViewController ltp_saveTipsToDocumentPath];
}

@end
