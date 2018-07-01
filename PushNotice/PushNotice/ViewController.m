//
//  ViewController.m
//  PushNotice
//
//  Created by yangrui on 2018/7/1.
//  Copyright © 2018年 yangrui. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

/**
在iOS8.0 之后,可以设置推送通知带操作行为
 */
-(void)sendLocalNotice{
    // 创建本地通知
    UILocalNotification *localNotice = [[UILocalNotification alloc]init];
    // 设置本地通知消息体
    localNotice.alertBody = @"有短消息了";
    // 设置本地通知触发时间
    localNotice.fireDate = [NSDate dateWithTimeIntervalSinceNow:4];
    
    // 以下是发送通知的额外 属性
    //1. 是否设置重复发送, NSCalendarUnitMinute 表示每隔一分钟发送一次
//    localNotice.repeatInterval =  NSCalendarUnitMinute;
    //2. 设置滑动解锁的文字
    localNotice.hasAction = YES;
    localNotice.alertAction = @"回复我";
    //3. 设置启动图片(点击通知时,App 展示的启动图片)
    localNotice.alertLaunchImage = @"abc";
    //4. 设置通知的标题
    localNotice.alertTitle = @"给你的惊喜";
    //5. 设置通知声音
    localNotice.soundName = UILocalNotificationDefaultSoundName;
    localNotice.soundName = @"xxx.aac";
    //6. 设置消息数
    localNotice.applicationIconBadgeNumber = 10;
    //7. 设置用户信息
    localNotice.userInfo = @{@"name":@"张三",@"pwd":@"123"};
    
    
    
    localNotice.category = @"selectCategory";
    
    
    // 因为发送推送通知是系统级别的事情,因次需要用Application  来执行
    // 立即发送通知
    // [[UIApplication sharedApplication] presentLocalNotificationNow:localNotice];
    
    // 根据通知设置的触发时间发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotice];
  
}



- (IBAction)sendNoticeBtnClick:(id)sender {
    [self sendLocalNotice];
    NSLog(@"发出通知");
}

- (IBAction)checkNoticeBtnClick:(id)sender {
    
    NSArray<UILocalNotification *> *localNoticeArr = [[UIApplication sharedApplication] scheduledLocalNotifications];

     NSLog(@"count ==> %ld",localNoticeArr.count);
    
}
- (IBAction)cancleNoticeBtnClick:(id)sender {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    [UIApplication sharedApplication] cancelLocalNotification:<#(nonnull UILocalNotification *)#>
}

@end
