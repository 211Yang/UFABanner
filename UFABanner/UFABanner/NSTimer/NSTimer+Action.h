//
//  NSTimer+Action.h
//  UFABanner
//
//  Created by Yang Lin on 2017/8/16.
//  Copyright © 2017年 Yang Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Action)


/**
 创建无引用循环问题的定时器

 @param timeInterval 定时器间隔
 @param block 定时器block
 @param repeats 是否重复
 @return 返回定时器实例
 */
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval
                                      block:(void(^)())block
                                    repeats:(BOOL)repeats;


/**
 定时器执行block方法

 @param timer 当前定时器
 */
+ (void)blockInvoke:(NSTimer *)timer;
    

/**
 暂停定时器
 */
-(void)pauseTimer;

/**
 开启定时器
 */
-(void)resumeTimer;


/**
 间隔几秒后开启定时器

 @param interval 间隔时间
 */
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
