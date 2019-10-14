//
//  LTPMusicModel.h
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTPMusicModel : NSObject

@property (nonatomic, copy) NSString *name; /**< 歌名*/
@property (nonatomic, copy) NSString *totalTime; /**< 时长*/
@property (nonatomic, copy) NSString *singerImage; /**< 歌图*/

@end

NS_ASSUME_NONNULL_END
