//
//  ZZSettingsTarget.m
//  PictureWords
//
//  Created by zhao on 2019/10/25.
//  Copyright © 2019 english. All rights reserved.
//

#import "ZZSettingsTarget.h"
#import "LTPSetTableViewController.h"

@implementation ZZSettingsTarget

- (LTPSetTableViewController *)st_provideSetVC
{
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *baseDirectory = [NSString stringWithFormat:@"%@.bundle", bundle.infoDictionary[@"CFBundleName"]];
    NSString *path = [bundle.bundlePath stringByAppendingPathComponent:baseDirectory];
    bundle = [NSBundle bundleWithPath:path];
    
    return [[UIStoryboard storyboardWithName:@"Settings" bundle:bundle] instantiateInitialViewController];
}

@end
