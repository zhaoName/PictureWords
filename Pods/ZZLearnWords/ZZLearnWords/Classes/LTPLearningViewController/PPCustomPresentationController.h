//
//  PPCustomPresentationController.h
//  ShorthandWords
//
//  Created by zhao on 2019/5/14.
//  Copyright © 2019 english. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPCustomPresentationController : UIPresentationController

@property (nonatomic, assign) CGRect cusFrame;/**< */
- (void)dismissBgView:(UITapGestureRecognizer *)tapGes;

@end

NS_ASSUME_NONNULL_END
