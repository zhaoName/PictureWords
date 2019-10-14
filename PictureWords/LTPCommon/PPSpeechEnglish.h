//
//  PPSpeechEnglish.h
//  KeywordPricatice
//
//  Created by famin on 2019/4/2.
//  Copyright © 2019年 keyword. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPSpeechEnglish : NSObject
+ (PPSpeechEnglish *)shareSpeech ;
- (void)speechKeyword:(NSString *)content ;
//- (void)speechKeywords:(NSString *)content ;
@end

NS_ASSUME_NONNULL_END
