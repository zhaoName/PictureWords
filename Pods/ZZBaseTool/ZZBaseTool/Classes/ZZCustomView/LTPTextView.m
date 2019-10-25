//
//  LTPTextView.m
//  PictureWords
//
//  Created by zhao on 2019/6/13.
//  Copyright © 2019 english. All rights reserved.
//

#import "LTPTextView.h"

@interface LTPTextView ()

@property (nonatomic, strong) UILabel *ltp_placeLabel; /**< 占位label*/

@end

@implementation LTPTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        [self initDatas];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ([super initWithCoder:aDecoder])
    {
        [self initDatas];
    }
    return self;
}

- (void)initDatas
{
    [self addSubview:self.ltp_placeLabel];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewContentDidChange) name:UITextViewTextDidChangeNotification object:nil];
    [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

// 直接掉text的setter方法赋值，移除占位文字
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSString *newText = change[NSKeyValueChangeNewKey];
    if (newText.length == 0) {
        [self addSubview:self.ltp_placeLabel];
    } else {
        [self.ltp_placeLabel removeFromSuperview];
    }
}

- (void)layoutSubviews
{
    self.ltp_placeLabel.text = self.ltp_placeHolder;
    self.ltp_placeLabel.font = [UIFont systemFontOfSize:self.ltp_systemFont];
    self.font = [UIFont systemFontOfSize:self.ltp_systemFont];
}

// 手动编辑UITextView时，移除占位文字
- (void)textViewContentDidChange
{
    if (self.text.length == 0) {
        [self addSubview:self.ltp_placeLabel];
    } else {
        [self.ltp_placeLabel removeFromSuperview];
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"text"];
}

#pragma mark -- getter

- (UILabel *)ltp_placeLabel
{
    if (!_ltp_placeLabel)
    {
        _ltp_placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, self.frame.size.width-10, 40)];
        _ltp_placeLabel.textColor = [UIColor lightGrayColor];
        _ltp_placeLabel.font = [UIFont systemFontOfSize:self.ltp_systemFont];
        _ltp_placeLabel.numberOfLines = 0;
    }
    return _ltp_placeLabel;
}


@end
