//
//  UIImage+LTPOrien.h
//  PictureWords
//
//  Created by zhao on 2019/9/11.
//  Copyright © 2019 english. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LTPOrien)

/**
 * 调整图片的方向
 */
- (UIImage *)ltp_fixOrientation;

+ (UIImage *)ltp_imageWithName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
