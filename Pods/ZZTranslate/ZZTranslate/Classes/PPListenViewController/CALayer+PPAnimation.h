//
//  CALayer+PPAnimation.h
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (PPAnimation)

/** 暂停动画*/
- (void)ltp_pauseAni;

/** 恢复动画*/
- (void)ltp_resumeAni;

@end

NS_ASSUME_NONNULL_END
