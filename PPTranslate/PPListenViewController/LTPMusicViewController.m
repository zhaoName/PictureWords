//
//  LTPMusicViewController.m
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import "LTPMusicViewController.h"
#import "LTPPlayMusicHandle.h"
#import "LTPListenModel.h"
#import <Masonry.h>
#import <MJExtension.h>

@interface LTPMusicViewController ()

@property (nonatomic, strong) UIImageView *bgImageView; /**< */
@property (nonatomic, strong) UIImageView *leftImageView; /**< */
@property (nonatomic, strong) UIImageView *singerImageView; /**< */
@property (nonatomic, strong) UIImageView *rightImageView; /**< */

@property (nonatomic, strong) UILabel *nameLabel; /**< */
@property (nonatomic, strong) UILabel *singerLabel; /**< */
@property (nonatomic, strong) UISlider *progressSlider; /**< 进度条*/
@property (nonatomic, strong) UILabel *currentTimeLabel; /**< 当前时间*/
@property (nonatomic, strong) UILabel *totalTiemLabel; /**< 总时间*/
@property (nonatomic, strong) UIButton *lastBtn; /**< 上一曲*/
@property (nonatomic, strong) UIButton *playBtn; /**< 播放*/
@property (nonatomic, strong) UIButton *nextBtn; /**< 下一曲*/

@property (nonatomic, strong) UIButton *backBtn; /**< */
@property (nonatomic, strong) NSTimer *timer; /**< 定时器*/

@property (nonatomic, strong) LTPListenModel *musicModel;/**< */

@end

@implementation LTPMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self ltp_setupSubviewsProperty];
    [self ltp_setupSubviewsContraints];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPlayFinish:) name:@"kNotificationMusicPlayFinsh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ltp_musicLoadFinish:) name:@"MusicLoadFinish" object:nil];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)ltp_musicLoadFinish:(NSNotification *)noti
{
    // 标题
    if ([LTPPlayMusicHandle ltp_shareMusicTool].ltp_isPlayingMusic) {
        self.timer.fireDate = [NSDate distantPast];
        self.playBtn.selected = NO;
    }
}

#pragma mark -- 设置子控件

- (void)ltp_setupSubviewsContraints
{
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.mas_equalTo(SCREEN_WIDTH * 245.0 / 375.0);
    }];
    
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (SCREEN_WIDTH == 375.0 && SCREEN_HEIGHT == 812.0) {
            make.top.equalTo(self.view).offset(44 + 7);
        } else {
            make.top.equalTo(self.view).offset(22 + 7);
        }
        make.left.equalTo(self.view).offset(18);
        make.size.mas_equalTo(CGSizeMake(29, 29));
    }];
    
    [self.view addSubview:self.singerImageView];
    [self.singerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgImageView.mas_bottom).offset(80 * Fit_HEIGHT);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(210*Fit_WIDTH, 210*Fit_WIDTH));
    }];
    
    [self.view addSubview:self.leftImageView];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.singerImageView.mas_centerY);
        make.right.equalTo(self.singerImageView.mas_left).offset(-52*Fit_WIDTH);
        make.size.mas_equalTo(CGSizeMake(130*Fit_WIDTH, 130*Fit_WIDTH));
    }];
    
    [self.view addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.singerImageView.mas_centerY);
        make.left.equalTo(self.singerImageView.mas_right).offset(52*Fit_WIDTH);
        make.size.mas_equalTo(CGSizeMake(130*Fit_WIDTH, 130*Fit_WIDTH));
    }];
    
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.singerImageView.mas_bottom).offset(44 * Fit_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(280, 21));
    }];
    
    [self.view addSubview:self.singerLabel];
    [self.singerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(6 * Fit_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(110, 17));
    }];
    
    [self.view addSubview:self.progressSlider];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.singerLabel.mas_bottom).offset(20 * Fit_HEIGHT);
        make.left.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 25, 0, 25));
    }];
    
    [self.view addSubview:self.currentTimeLabel];
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.progressSlider.mas_leading);
        make.top.equalTo(self.progressSlider.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(50, 17));
    }];
    
    [self.view addSubview:self.totalTiemLabel];
    [self.totalTiemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.progressSlider.mas_trailing);
        make.top.equalTo(self.progressSlider.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(50, 17));
    }];
    
    [self.view addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressSlider.mas_bottom).offset(51 * Fit_HEIGHT);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    CGFloat space = ((SCREEN_WIDTH - 80) * 0.5 - 58) * 0.33;
    [self.view addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playBtn.mas_centerY);
        make.left.equalTo(self.playBtn.mas_right).offset(space);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.view addSubview:self.lastBtn];
    [self.lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playBtn.mas_centerY);
        make.right.equalTo(self.playBtn.mas_left).offset(-space);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

// 设置子控件属性
- (void)ltp_setupSubviewsProperty
{
    self.musicModel = [LTPPlayMusicHandle ltp_shareMusicTool].musicArray[[LTPPlayMusicHandle ltp_shareMusicTool].currentIndex];
    self.view.backgroundColor = RGB(237, 237, 237);
    self.navigationItem.title = [self.musicModel.title substringFromIndex:9];
    // 设置子控件
    self.currentTimeLabel.text = [self getFormatTimeWithTimeInterval:[LTPPlayMusicHandle ltp_shareMusicTool].currntMusicPlayTime];
    self.totalTiemLabel.text = [self getFormatTimeWithTimeInterval:self.musicModel.duration];
    self.nameLabel.text = self.musicModel.title;
    self.singerImageView.image = [UIImage imageNamed:@"logo"];
    self.leftImageView.image = [UIImage imageNamed:@"logo"];
    self.rightImageView.image = [UIImage imageNamed:@"logo"];
    
    // 设置进度条 最小/最大值
    self.progressSlider.minimumValue = 0;
    self.progressSlider.maximumValue = self.musicModel.duration;
    self.progressSlider.value = [LTPPlayMusicHandle ltp_shareMusicTool].currntMusicPlayTime;
    self.playBtn.selected = ![LTPPlayMusicHandle ltp_shareMusicTool].ltp_isPlayingMusic;
}

#pragma mark -- action

// 返回
- (void)clickLeftItem:(UIBarButtonItem *)leftItem
{
    if ([LTPPlayMusicHandle ltp_shareMusicTool].ltp_isPlayingMusic) {
        self.PPFetchCurrentPlayIndex([LTPPlayMusicHandle ltp_shareMusicTool].currentIndex);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// 上一曲
- (void)touchLasteBtn:(UIButton *)btn
{
    if (self.playBtn.selected) self.playBtn.selected = NO;
    
    [self playMusicWithPlayType:NO isAuto:NO];
}

// 播放/暂停
- (void)touchPlayBtn:(UIButton *)btn
{
    if ([LTPPlayMusicHandle ltp_shareMusicTool].player == nil) {
        [[LTPPlayMusicHandle ltp_shareMusicTool] ltp_playerMusicWithName:self.musicModel.filename url:self.musicModel.mp3];
        return;
    }
    if (!btn.selected) {
        [[LTPPlayMusicHandle ltp_shareMusicTool] ltp_pauseAudioPlayer];
        btn.selected = YES;
        self.timer.fireDate = [NSDate distantFuture];
    }
    else {
        [[LTPPlayMusicHandle ltp_shareMusicTool] ltp_playAudioPlayer];
        btn.selected = NO;
        self.timer.fireDate = [NSDate distantPast];
    }
}

// 下一曲
- (void)touchNextBtn:(UIButton *)btn
{
    if (self.playBtn.selected) self.playBtn.selected = NO;
    
    [self playMusicWithPlayType:YES isAuto:NO];
}

#pragma mark -- 进度条时间

- (void)progressViewTouchDown
{
    self.timer.fireDate = [NSDate distantFuture];
}

- (void)progressViewTouchUp
{
    self.timer.fireDate = [NSDate distantPast];
}

- (void)progressViewValueChange
{
    // 更新时长
    self.currentTimeLabel.text = [self getFormatTimeWithTimeInterval:self.progressSlider.value];
    [LTPPlayMusicHandle ltp_shareMusicTool].currntMusicPlayTime = self.progressSlider.value;
}

#pragma mark -- private method

// 更新当前音乐播放时长
- (void)updateMusicTime
{
    // 播放时长
    NSString *time = [self getFormatTimeWithTimeInterval:[[LTPPlayMusicHandle ltp_shareMusicTool] currntMusicPlayTime]];
    self.currentTimeLabel.text = time;
    
    // 进度条
    self.progressSlider.value = [[LTPPlayMusicHandle ltp_shareMusicTool] currntMusicPlayTime];
}

// 播放完成之后的操作
- (void)musicPlayFinish:(NSNotification *)noti
{
    [self playMusicWithPlayType:YES isAuto:YES];
}

// 由播放模式
- (void)playMusicWithPlayType:(BOOL)isNext isAuto:(BOOL)isAuto
{
    [[LTPPlayMusicHandle ltp_shareMusicTool] ltp_playMusicWithPlayTypeAndisNext:isNext isAutoPlay:isAuto];
    [self ltp_setupSubviewsProperty];
}

#pragma mark -- getter

- (UIImageView *)bgImageView
{
    if (!_bgImageView)
    {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_bg"]];
    }
    return _bgImageView;
}

- (UIImageView *)singerImageView
{
    if (!_singerImageView)
    {
        _singerImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _singerImageView.clipsToBounds = YES;
        _singerImageView.layer.cornerRadius = 8.0;
    }
    return _singerImageView;
}

- (UIImageView *)leftImageView
{
    if (!_leftImageView)
    {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _leftImageView.clipsToBounds = YES;
        _leftImageView.layer.cornerRadius = 5.0;
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView
{
    if (!_rightImageView)
    {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightImageView.clipsToBounds = YES;
        _rightImageView.layer.cornerRadius = 5.0;
    }
    return _rightImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)singerLabel
{
    if (!_singerLabel)
    {
        _singerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _singerLabel.textColor = RGB(100, 100, 100);
        _singerLabel.textAlignment = NSTextAlignmentCenter;
        _singerLabel.font = [UIFont systemFontOfSize:13];
    }
    return _singerLabel;
}

- (UILabel *)currentTimeLabel
{
    if (!_currentTimeLabel)
    {
        _currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _currentTimeLabel.textColor = [UIColor grayColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:16];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.text = @"00:00";
    }
    return _currentTimeLabel;
}

- (UILabel *)totalTiemLabel
{
    if (!_totalTiemLabel)
    {
        _totalTiemLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _totalTiemLabel.textColor = [UIColor grayColor];
        _totalTiemLabel.font = [UIFont systemFontOfSize:16];
        _totalTiemLabel.textAlignment = NSTextAlignmentCenter;
        _totalTiemLabel.text = @"02:56";
    }
    return _totalTiemLabel;
}

- (UISlider *)progressSlider
{
    if (!_progressSlider)
    {
        _progressSlider = [[UISlider alloc] initWithFrame:CGRectZero];
        _progressSlider.minimumTrackTintColor = [UIColor ltp_colorWithHexString:@"0x44bb88"];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateSelected];
        
        [_progressSlider addTarget:self action:@selector(progressViewTouchDown) forControlEvents:UIControlEventTouchDown];
        [_progressSlider addTarget:self action:@selector(progressViewTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [_progressSlider addTarget:self action:@selector(progressViewValueChange) forControlEvents:UIControlEventValueChanged];
    }
    return _progressSlider;
}

- (UIButton *)lastBtn
{
    if (!_lastBtn)
    {
        _lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lastBtn setImage:[UIImage imageNamed:@"previous-play"] forState:UIControlStateNormal];
        [_lastBtn setImage:[UIImage imageNamed:@"previous-play"] forState:UIControlStateHighlighted];
        [_lastBtn addTarget:self action:@selector(touchLasteBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lastBtn;
}

- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        _playBtn.selected = false;
        [_playBtn addTarget:self action:@selector(touchPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setImage:[UIImage imageNamed:@"next-play"] forState:UIControlStateNormal];
        [_nextBtn setImage:[UIImage imageNamed:@"next-play"] forState:UIControlStateHighlighted];
        [_nextBtn addTarget:self action:@selector(touchNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}
- (UIButton *)backBtn
{
    if (!_backBtn)
    {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(clickLeftItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateMusicTime) userInfo:nil repeats:YES];
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
