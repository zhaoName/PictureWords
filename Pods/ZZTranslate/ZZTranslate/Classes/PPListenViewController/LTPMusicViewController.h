//
//  LTPMusicViewController.h
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTPMusicViewController : UIViewController

@property (nonatomic, strong) void(^PPFetchCurrentPlayIndex)(NSInteger index); /**< */

@end

NS_ASSUME_NONNULL_END
