//
//  PPSpeechEnglish.m
//  KeywordPricatice
//
//  Created by famin on 2019/4/2.
//  Copyright © 2019年 keyword. All rights reserved.
//

#import "PPSpeechEnglish.h"
#import <AVFoundation/AVFoundation.h>
@interface PPSpeechEnglish ()
@property (nonatomic,strong) AVSpeechSynthesizer *speaker ;
@property (nonatomic,strong) AVSpeechUtterance *content ;
@end
@implementation PPSpeechEnglish
+ (void)load
{
    [self shareSpeech];
}
+ (PPSpeechEnglish *)shareSpeech
{
    static id _instance = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [[PPSpeechEnglish alloc] init];
        }
    });
    return _instance ;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.speaker = [[AVSpeechSynthesizer alloc] init];
        //需要转换的文本
        self.content = [[AVSpeechUtterance alloc] initWithString:@"grape"];
        //国家语言
        self.content.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
        //声速
        self.content.rate = 0.4f;
        self.content.volume = 1.0 ;
    }
    return self ;
}

- (void)speechKeyword:(NSString *)content
{
    self.content = [[AVSpeechUtterance alloc] initWithString:content];
    [self.speaker speakUtterance:self.content];
}


@end
