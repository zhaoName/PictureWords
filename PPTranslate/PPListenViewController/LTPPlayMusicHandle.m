//
//  LTPPlayMusicHandle.m
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import "LTPPlayMusicHandle.h"
#import <MJExtension.h>
#import "LTPListenModel.h"
#import "UIViewController+LTPHUD.h"

static LTPPlayMusicHandle *_tool = nil;
@interface LTPPlayMusicHandle ()<AVAudioPlayerDelegate>

@property (nonatomic, assign) NSInteger index; /**< */

@end

@implementation LTPPlayMusicHandle

@synthesize currntMusicPlayTime = _currntMusicPlayTime;

+ (LTPPlayMusicHandle *)ltp_shareMusicTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_tool == nil) {
            _tool = [[LTPPlayMusicHandle alloc] init];
        }
    });
    return _tool;
}

- (instancetype)init
{
    if ([super init])
    {
        // 获取音频会话
        AVAudioSession *session = [AVAudioSession sharedInstance];
        // 设置会话类别为后台播放
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        // 激活会话
        [session setActive:YES error:nil];
    }
    return self;
}

// 播放
- (void)ltp_playerMusicWithName:(NSString *)name url:(NSString *)url
{
    if (name.length == 0) return;
    
    NSString *musicPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    musicPath = [musicPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a", name]];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController ltp_showActivityIndicatorViewWithMessage:nil];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [data writeToFile:musicPath atomically:YES];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSError *error = nil;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:musicPath] error:&error];
        self.player.delegate = self;
        self.player.numberOfLoops = 0;
        [self.player prepareToPlay];
        [self.player play];
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
        [[UIApplication sharedApplication].keyWindow.rootViewController ltp_hiddenActivityIndicatorView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MusicLoadFinish" object:nil];
    });
}

- (void)ltp_playAudioPlayer
{
    [self.player play];
}

// 暂停当前正在播放的音乐
- (void)ltp_pauseAudioPlayer
{
    [self.player pause];
}

// 停止当前正在播放的音乐
- (void)ltp_stopAudioPlayer
{
    [self.player stop];
    self.player = nil;
}

// 是否正在播放
- (BOOL)ltp_isPlayingMusic
{
    return [self.player isPlaying];
}

// 上一曲或下一曲
- (void)ltp_playMusicWithPlayTypeAndisNext:(BOOL)isNext isAutoPlay:(BOOL)isAuto
{
    // 由播放模式 确定下一曲的下标
    if (isAuto) {
        self.currentIndex++;
    } else {
        isNext ? self.currentIndex++ : self.currentIndex--;
    }
    // 下标越界问题
    if (isNext) {
        if (self.currentIndex >= self.musicArray.count) self.currentIndex = 0;
    } else {
        if (self.currentIndex < 0) self.currentIndex = self.musicArray.count - 1;
    }
    LTPListenModel *model = self.musicArray[self.currentIndex];
    [self ltp_playerMusicWithName:model.filename url:model.mp3];
}

#pragma mark - AVAudioPlayerDelegate
/**
 *  音乐播放完成, 发送通知告诉外界
 *
 *  @param player 音乐播放器
 *  @param flag   是否完成
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotificationMusicPlayFinsh" object:self.player];
        NSLog(@"播放完成");
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"播放error:%@", error.localizedDescription);
}

#pragma mark -- getter or setter

- (void)setCurrntMusicPlayTime:(NSTimeInterval)currntMusicPlayTime
{
    _currntMusicPlayTime = currntMusicPlayTime;
    self.player.currentTime = currntMusicPlayTime;
}

- (NSTimeInterval)currntMusicPlayTime
{
    return self.player.currentTime;
}

- (NSMutableArray *)musicArray
{
    if (!_musicArray)
    {
        _musicArray = [[NSMutableArray alloc] init];
    }
    return _musicArray;
}


@end
