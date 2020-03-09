//
//  ViewController.m
//  01-本地推送通知
//
//  Created by yangrui on 2020/3/8.
//  Copyright © 2020 yangrui. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)sendLocalNotice:(id)sender {
    
//    [self liJiSendLocalNotice];
     
    [self delaySendLocalNotice];
}


// 立即发送本地通知
-(void)liJiSendLocalNotice{
    // 发送一个本地通知
    // 1. 创建一个通知
    UILocalNotification *localNotice = [[UILocalNotification alloc]init];
    // 1.1 设置通知的必选内容
    
    // 通知的内容
    localNotice.alertBody = @"立即发送第一个本地";
    
    // 2. 发送通知
    // 通知是一个应用程序级别的操作, 也就意味着, 如果想要操纵通知必须使用UIApplication
    
    // 立即发送本地通知
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotice];
    
}

-(void)delaySendLocalNotice{
    // 发送一个本地通知
    // 1. 创建一个通知
    UILocalNotification *localNotice = [[UILocalNotification alloc]init];
    // 1.1 设置通知的必选内容
    
    // 通知的内容
    localNotice.alertBody = @"立即发送第一个本地";
    localNotice.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    
    // 2. 发送通知
    // 通知是一个应用程序级别的操作, 也就意味着, 如果想要操纵通知必须使用UIApplication
    
    // 按计划发送本地通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotice];
    
}



- (IBAction)cancleLocalNotice:(id)sender {
    // 取消所有的本地推送通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UILocalNotification *locNotice ;
    [[UIApplication sharedApplication] cancelLocalNotification:locNotice];
}
- (IBAction)chaKanLocalNotice:(id)sender {
    
    
    NSLog(@"%@",[[UIApplication sharedApplication] scheduledLocalNotifications] );
}

@end
