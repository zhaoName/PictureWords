//
//  LTPListenModel.h
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTPListenModel : NSObject

@property (nonatomic, copy) NSString *lrc;/**< */
@property (nonatomic, copy) NSString *mp3;/**< */
@property (nonatomic, copy) NSString *title;/**< */
@property (nonatomic, copy) NSString *filename;/**< */

@property (nonatomic, assign) NSUInteger update_time;/**< 更新时间 ms*/
@property (nonatomic, assign) NSInteger size;/**< 文件大小 kb*/
@property (nonatomic, assign) NSInteger duration;/**< 时长 秒*/

@end

NS_ASSUME_NONNULL_END
