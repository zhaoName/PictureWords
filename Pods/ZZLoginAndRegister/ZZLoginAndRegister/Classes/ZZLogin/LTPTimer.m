//
//  LTPTimer.m
//  PictureWords
//
//  Created by zhao on 2019/9/11.
//  Copyright © 2019 english. All rights reserved.
//

#import "LTPTimer.h"

static NSMutableDictionary *timeIntervalDict;
static NSMutableDictionary *timerDict;

@implementation LTPTimer

+ (dispatch_source_t)startTimerWithKey:(NSString *)timeKey andTimeBtn:(UIButton *)timeBtn
{
    if(!timeIntervalDict) {
        timeIntervalDict = [NSMutableDictionary dictionary];
    }
    if(!timerDict) {
        timerDict = [NSMutableDictionary dictionary];
    }
    [timeIntervalDict setObject:@(CFAbsoluteTimeGetCurrent()) forKey:timeKey];
    
    return [self showCountdownWithKey:timeKey OnTimeBtn:timeBtn forceStart:YES];
}


+ (dispatch_source_t)showCountdownWithKey:(NSString *)timeKey OnTimeBtn:(UIButton *)timeBtn forceStart:(BOOL)forceStart
{
    //倒计时时间长度
    __block NSTimeInterval leftTime = 45 - CFAbsoluteTimeGetCurrent() + [[timeIntervalDict objectForKey:timeKey] doubleValue];
    if(!forceStart && leftTime <= 0) return nil;
    
    //创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0*NSEC_PER_SEC, 0.0);//每秒执行一次
    
    dispatch_source_set_event_handler(timer, ^{
        
        if(leftTime < 0)//倒计时结束
        {
            dispatch_source_cancel(timer);//必须加这句代码 否则定时器不工作
            dispatch_async(dispatch_get_main_queue(), ^{
                
                timeBtn.userInteractionEnabled = YES;
                timeBtn.alpha = 1.0;
                [timeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            });
        }
        else//倒计时进行中
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [timeBtn setTitle:[NSString stringWithFormat:@"%.0f秒后重发", leftTime] forState:UIControlStateNormal];
                timeBtn.alpha = 0.65;
                timeBtn.userInteractionEnabled = NO;
            });
            leftTime--;
        }
    });
    
    [timerDict setObject:timer forKey:@"timer"];
    dispatch_resume(timer);//启动定时器
    
    return timer;
}

//取消定时器
+ (void)invalidate
{
    dispatch_source_t timer = timerDict[@"timer"];
    
    if(timer)
    {
        dispatch_source_cancel(timer);
        [timerDict removeObjectForKey:@"timer"];
    }
}
@end
