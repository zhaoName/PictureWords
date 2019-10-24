//
//  LTPTimer.h
//  PictureWords
//
//  Created by zhao on 2019/9/11.
//  Copyright © 2019 english. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTPTimer : NSObject


/**
 *  初始化字典 开始定时器 并记录开始时间
 *
 *  @param timeKey   开始时间的key
 *  @param timeBtn 显示倒计时的label
 */
+ (dispatch_source_t)startTimerWithKey:(NSString *)timeKey andTimeBtn:(UIButton *)timeBtn;

/**
 *  定时器工作 并显示处理业务
 *
 *  @param forceStart 是否启动定时器（第一次进入注册界面时不需要走定时器）
 */
+ (dispatch_source_t)showCountdownWithKey:(NSString *)timeKey OnTimeBtn:(UIButton *)timeBtn forceStart:(BOOL)forceStart;

/**取消定时器*/
+ (void)invalidate;

@end

NS_ASSUME_NONNULL_END
