//
//  PLTPPlayListenViewController.m
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import "PLTPPlayListenView.h"
#import "CALayer+PPAnimation.h"
#import <Masonry.h>
#import "LTPPlayMusicHandle.h"
#import <MJExtension.h>
#import "LTPListenModel.h"

@interface PLTPPlayListenView ()

@property (nonatomic, strong) UIImageView *singerImageView; /**< */
@property (nonatomic, strong) UIProgressView *progressView; /**< */
@property (nonatomic, strong) UILabel *nameLabel; /**< */
@property (nonatomic, strong) UIButton *playingBtn; /**< */
@property (nonatomic, strong) UIButton *nextBtn; /**< */

@property (nonatomic, strong) NSTimer *timer; /**< */
@property (nonatomic, copy) NSString *totalLength; /**< 歌曲总时长*/
@end

@implementation PLTPPlayListenView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToPlayingMusicVC)]];
    
    [self addSubview:self.singerImageView];
    [self.singerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).insets(UIEdgeInsetsMake(-8, 10, 0, 0));
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self).insets(UIEdgeInsetsMake(8, 0, 0, 8));
        make.left.equalTo(self.singerImageView.mas_right).offset(8);
    }];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView).offset(10);
        make.left.equalTo(self.singerImageView.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(180, 17));
    }];
    
    [self addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(8);
        make.right.equalTo(self.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self addSubview:self.playingBtn];
    [self.playingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(8);
        make.right.equalTo(self.nextBtn.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
}

- (void)ltp_playMusicWithModel:(LTPListenModel *)model
{
    self.nameLabel.text = [model.title substringFromIndex:9];
    
    self.totalLength = [self getFormatTimeWithTimeInterval:model.duration];
    self.timer.fireDate = [NSDate distantPast];
    [self singerImageViewBeginRotation];
}

#pragma mark -- Action

// 跳转到音乐播放界面
- (void)jumpToPlayingMusicVC
{
    if ([self.delegate respondsToSelector:@selector(jumpToPlayingVC)]) {
        [self.delegate jumpToPlayingVC];
    }
}
//
// 播放/暂停
- (void)touchPlayingBtn:(UIButton *)btn
{
    btn.selected = ![[LTPPlayMusicHandle ltp_shareMusicTool] ltp_isPlayingMusic];
    if ([[LTPPlayMusicHandle ltp_shareMusicTool] ltp_isPlayingMusic]) {
        
        [[LTPPlayMusicHandle ltp_shareMusicTool] ltp_pauseAudioPlayer];
        self.timer.fireDate = [NSDate distantFuture];
        [self singerImageViewPauseRotation];
    }
    else {
        [[LTPPlayMusicHandle ltp_shareMusicTool] ltp_playAudioPlayer];
        self.timer.fireDate = [NSDate distantPast];
        [self singerImageViewResumeRotation];
    }
}

// 下一曲
- (void)touchNextBtn:(UIButton *)btn
{
    self.playingBtn.selected = YES;
    if ([self.delegate respondsToSelector:@selector(playNextMusic)]) {
        [self.delegate playNextMusic];
    }
}

// 显示歌曲播放进度
- (void)showMusicProgress
{
    self.progressView.progress = [[LTPPlayMusicHandle ltp_shareMusicTool] currntMusicPlayTime] / [self getTimeIntervalWithFormatTime:self.totalLength];
}

#pragma mark -- 头像旋转

/**
 * 开始旋转
 */
- (void)singerImageViewBeginRotation
{
    [self.singerImageView.layer removeAnimationForKey:@"rotation"];
    
    CABasicAnimation *rotationAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAni.fromValue = @(0);
    rotationAni.toValue = @(M_PI * 2);
    rotationAni.duration = 30.0;
    rotationAni.repeatCount = MAXFLOAT;
    rotationAni.removedOnCompletion = NO;
    [self.singerImageView.layer addAnimation:rotationAni forKey:@"rotation"];
}

// 暂停动画
- (void)singerImageViewPauseRotation
{
    [self.singerImageView.layer ltp_pauseAni];
}

// 恢复动画
- (void)singerImageViewResumeRotation
{
    [self.singerImageView.layer ltp_resumeAni];
}

#pragma mark -- getter

- (UIImageView *)singerImageView
{
    if (!_singerImageView)
    {
        _singerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        _singerImageView.layer.cornerRadius = 30.0;
        _singerImageView.clipsToBounds = YES;
    }
    return _singerImageView;
}

- (UIProgressView *)progressView
{
    if (!_progressView)
    {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor ltp_colorWithHexString:@"0x44bb88"];
    }
    return _progressView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.text = @"Picture Words";
    }
    return _nameLabel;
}

- (UIButton *)playingBtn
{
    if (!_playingBtn)
    {
        _playingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playingBtn setImage:[UIImage imageNamed:@"home_play"] forState:UIControlStateNormal];
        [_playingBtn setImage:[UIImage imageNamed:@"home_pause"] forState:UIControlStateSelected];
        [_playingBtn addTarget:self action:@selector(touchPlayingBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playingBtn;
}

- (UIButton *)nextBtn
{
    if (!_nextBtn)
    {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setImage:[UIImage imageNamed:@"home_next"] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(touchNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (NSTimer *)timer
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showMusicProgress) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}


- (NSString *)getFormatTimeWithTimeInterval:(NSTimeInterval)timeInterval
{
    // 获取分钟数
    NSInteger min = timeInterval / 60;
    // 获取秒数
    NSInteger sec = (NSInteger)timeInterval % 60;
    // 返回计算后的数值
    return [NSString stringWithFormat:@"%02zd:%02zd", min, sec];
}

- (NSUInteger)getTimeIntervalWithFormatTime:(NSString *)format
{
    // 分解分钟和秒数
    NSArray *minAsec = [format componentsSeparatedByString:@":"];
    // 获取分钟
    NSString *min = [minAsec firstObject];
    // 获取秒数
    NSString *sec = [minAsec lastObject];
    
    // 计算, 并返回值
    return min.intValue * 60 + sec.integerValue;
}



@end
