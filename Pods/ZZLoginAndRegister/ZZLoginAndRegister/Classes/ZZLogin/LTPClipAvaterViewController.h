//
//  LTPClipAvaterViewController.h
//  PictureWords
//
//  Created by zhao on 2019/9/11.
//  Copyright © 2019 english. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LTPClipAvaterViewControllerDelegate <NSObject>

- (void)didSuccessClipImage:(UIImage *)clipedImage;

@end

@interface LTPClipAvaterViewController : UIViewController

@property (nonatomic, strong) UIImage *needClipImage;
@property (nonatomic, weak) id<LTPClipAvaterViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
