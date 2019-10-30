//
//  LTPPlayMusicHandle.h
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTPPlayMusicHandle : NSObject

@property (nonatomic, strong) AVAudioPlayer *player; /**< 播放器*/
@property (nonatomic, assign) NSTimeInterval currntMusicPlayTime; /**< 播放时间*/
@property (nonatomic, assign) NSInteger currentIndex; /**< */
@property (nonatomic, strong) NSMutableArray *musicArray; /**< */


+ (LTPPlayMusicHandle *)ltp_shareMusicTool;

/**
 创建音乐播放器
 */
- (void)ltp_playerMusicWithName:(NSString *)name url:(NSString *)url;

/**
 * 播放音乐
 */
- (void)ltp_playAudioPlayer;

/**
 * 暂停当前播放音乐
 */
- (void)ltp_pauseAudioPlayer;

/**
 * 停止播放
 */
- (void)ltp_stopAudioPlayer;

/**
 * 是否正在播放
 */
- (BOOL)ltp_isPlayingMusic;

/**
 根据播放模式 和是否下一曲，播放歌曲（包括上一曲、下一曲、播放完成后自动播放下一曲）
 
 @param isNext YES:下一曲, NO:上一曲
 @param isAuto YES:播放完成自动播放下一首 NO:手动点击下一曲
 */
- (void)ltp_playMusicWithPlayTypeAndisNext:(BOOL)isNext isAutoPlay:(BOOL)isAuto;

@end

NS_ASSUME_NONNULL_END
