//
//  ZZMediator+ZZLearnWords.h
//  ZZLearnWords_Example
//
//  Created by zhao on 2019/10/31.
//  Copyright © 2019 zhaoName. All rights reserved.
//

#import <ZZMediator/ZZMediator.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZMediator (ZZLearnWords)

- (UIViewController *)learn_fetchHomeVC;
- (UIViewController *)learn_fetchCollectionVC;

@end

NS_ASSUME_NONNULL_END
