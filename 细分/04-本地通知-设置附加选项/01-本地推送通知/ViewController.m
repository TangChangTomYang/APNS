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
    
 
     
    [self delaySendLocalNotice];
}

-(void)test{
    /**
     
     */
}

 
-(void)delaySendLocalNotice{
    // 发送一个本地通知
    // 1. 创建一个通知
    UILocalNotification *localNotice = [[UILocalNotification alloc]init];
    // 1.1 设置通知的必选内容
    
    // 通知的内容
    localNotice.alertBody = @"立即发送第一个本地";
    localNotice.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    
    // 发送通知的附加选项内容
//        localNotice.repeatInterval = NSCalendarUnitSecond;
//        localNotice.region; // 可以设置, 当进入或者离开一个region时发送通知
//        localNotice.regionTriggersOnce; // 进入区域是否只执行一些
//        localNotice.hasAction = YES ; // 是否允许滑动提示文字
//        localNotice.alertAction = @"滑动看看"; // 滑动解锁的提示文字
//        
//        localNotice.alertLaunchImage;// 设置启动图片
        localNotice.alertTitle = @"通知列表显示的标题";  // 通知列表显示 的通知标题
        
    //    localNotice.soundName = @"win.acc"; // 通知的声音文件名
        localNotice.soundName = UILocalNotificationDefaultSoundName; // 这个是默认的通知声音名(可能没声音)]
        
        // 设置图标 数字
        localNotice.applicationIconBadgeNumber = 10;
        
        // 通知传递的额外参数
        localNotice.userInfo = @{@"name": @"zhangsan", @"age": @18};
    
    
    // 设置本地推送通知的操作选项组 (也就是从 添加的category set 中选一个category)
//    localNotice.category = @"Yes_or_no_notice";
    localNotice.category = @"send_msg_notice";
    
    
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
