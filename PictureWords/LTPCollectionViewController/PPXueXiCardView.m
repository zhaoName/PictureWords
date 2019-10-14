//
//  PPXueXiCardView.m
//  LearnWord
//
//  Created by zhao on 2019/4/9.
//  Copyright © 2019 english. All rights reserved.
//

#import "PPXueXiCardView.h"
#import <Masonry.h>
#import "PPSpeechEnglish.h"

@interface PPXueXiCardView()

@property (strong, nonatomic) UILabel *enNameLabel;
@property (strong, nonatomic) UILabel *typeLabel;
@property (strong, nonatomic) UILabel *chNameLabel;
@property (strong, nonatomic) UIButton *speakerBtn;
@property (strong, nonatomic) UIImageView *echImageV;
@property (strong, nonatomic) UILabel *enSenLabel;
@property (strong, nonatomic) UILabel *chSenLabel;


@end


@implementation PPXueXiCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubviewsProperty];
    }
    return self;
}

- (void)initSubviewsProperty
{
    [self addSubview:self.enNameLabel];
    [self.enNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).insets(UIEdgeInsetsMake(15, 15, 0, 0));
        make.size.mas_equalTo(CGSizeMake(100, 25));
    }];
    [self addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.enNameLabel.mas_centerY);
        make.left.equalTo(self.enNameLabel.mas_right).offset(10);
    }];
    [self addSubview:self.chNameLabel];
    [self.chNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.enNameLabel.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(20);
    }];
    
    [self addSubview:self.speakerBtn];
    [self.speakerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.enNameLabel.mas_bottom).offset(5);
        make.right.equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(21, 20));
    }];
    
    [self addSubview:self.echImageV];
    [self.echImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-15);
        make.width.mas_equalTo(self.frame.size.width * 3 / 5);
        make.height.mas_equalTo(self.frame.size.width * 3 / 5);
    }];

    [self addSubview:self.chSenLabel];
    [self.chSenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self).insets(UIEdgeInsetsMake(0, 15, 10, 15));
        make.height.mas_equalTo(40);
    }];
    [self addSubview:self.enSenLabel];
    [self.enSenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.chSenLabel.mas_top).offset(-8);
        make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 15, 0, 15));
        make.height.mas_equalTo(40);
    }];
}

- (void)touchSpeakerBtn:(UIButton *)sender
{
    [[PPSpeechEnglish shareSpeech] speechKeyword:self.enNameLabel.text];
}


- (void)showCardView:(DataModel *)model
{
    CGSize size = [model.keywordEnglish boundingRectWithSize:CGSizeMake(100000, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24]} context:nil].size;
    [self.enNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).insets(UIEdgeInsetsMake(15, 15, 0, 0));
        make.size.mas_equalTo(CGSizeMake(size.width+10, 25));
    }];
    self.enNameLabel.text = model.keywordEnglish;
    self.typeLabel.text = model.keywordStyle;
    self.chNameLabel.text = model.keywordChina;
    self.chSenLabel.text = model.contentChina;
    self.enSenLabel.text = model.contentEnglish;
    self.echImageV.image = [UIImage imageNamed:model.keywordImageName];
}

#pragma mark -- getter

- (UILabel *)enNameLabel
{
    if (!_enNameLabel) {
        _enNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _enNameLabel.textColor = [UIColor ltp_mainRedColor];
        _enNameLabel.font = [UIFont boldSystemFontOfSize:24];
    }
    return _enNameLabel;
}

- (UILabel *)chNameLabel
{
    if (!_chNameLabel) {
        _chNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _chNameLabel.textColor = [UIColor blackColor];
        _chNameLabel.font = [UIFont systemFontOfSize:18];
    }
    return _chNameLabel;
}

- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _typeLabel.textColor = UIColorWithHex(0x999999);
        _typeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _typeLabel;
}

- (UIImageView *)echImageV
{
    if (!_echImageV) {
        _echImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
        _echImageV.layer.cornerRadius = 5;
        _echImageV.clipsToBounds = YES;
    }
    return _echImageV;
}

- (UIButton *)speakerBtn
{
    if (!_speakerBtn) {
        _speakerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_speakerBtn setImage:[UIImage imageNamed:@"speaker"] forState:UIControlStateNormal];
        [_speakerBtn addTarget:self action:@selector(touchSpeakerBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _speakerBtn;
}

- (UILabel *)enSenLabel
{
    if (!_enSenLabel) {
        _enSenLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _enSenLabel.textColor = UIColorWithHex(0x666666);
        _enSenLabel.font = [UIFont systemFontOfSize:16];
        _enSenLabel.numberOfLines = 2;
    }
    return _enSenLabel;
}

- (UILabel *)chSenLabel
{
    if (!_chSenLabel) {
        _chSenLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _chSenLabel.textColor = UIColorWithHex(0x666666);
        _chSenLabel.font = [UIFont systemFontOfSize:16];
        _chSenLabel.numberOfLines = 2;
    }
    return _chSenLabel;
}


@end
