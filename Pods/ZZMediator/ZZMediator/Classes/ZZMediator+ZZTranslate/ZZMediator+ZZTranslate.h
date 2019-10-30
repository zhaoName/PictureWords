//
//  ZZMediator+ZZTranslate.h
//  ZZTranslate_Example
//
//  Created by zhao on 2019/10/29.
//  Copyright © 2019 zhaoName. All rights reserved.
//

#import <ZZMediator/ZZMediator.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZMediator (ZZTranslate)

- (UIViewController *)trans_fetchTranslateVC;
- (void)trans_getTipsFromPlistFile;

@end

NS_ASSUME_NONNULL_END
