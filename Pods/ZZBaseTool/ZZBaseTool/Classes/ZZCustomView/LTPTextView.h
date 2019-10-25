//
//  LTPTextView.h
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTPTextView : UITextView

@property (nonatomic, assign) CGFloat ltp_systemFont; /**< 字体大小*/
@property (nonatomic, strong) NSString *ltp_placeHolder; /**< 占位文字*/

@end

NS_ASSUME_NONNULL_END
