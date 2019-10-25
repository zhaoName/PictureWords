//
//  ZZMediator+ZZSettings.m
//  PictureWords
//
//  Created by zhao on 2019/10/25.
//  Copyright © 2019 english. All rights reserved.
//

#import "ZZMediator+ZZSettings.h"


@implementation ZZMediator (ZZSettings)

- (UIViewController *)settings_fetchSettingsVC
{
    return [self zz_preformTagert:@"ZZSettingsTarget" action:@"st_provideSetVC" params:@{} shouldCache:NO];
}

@end
