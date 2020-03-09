//
//  AppDelegate.m
//  01-本地推送通知
//
//  Created by yangrui on 2020/3/8.
//  Copyright © 2020 yangrui. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end
/**
申请的后台任务标识
app进入后台时, 申请后台任务, 返回后台任务标识
app从后台返回前台时, 如果申请的后台任务还没结束, 需要结束后台任务
*/
static UIBackgroundTaskIdentifier _bgTask;
@implementation AppDelegate

 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 注册本地推送t通知
    [self registLocalNotice];
  
    return YES;
}

// 注册本地推送t通知
-(void)registLocalNotice{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication ] registerUserNotificationSettings:setting];
    }
}


 
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 开启后台任务
    [self beginBackgroundTask];
}

-(void)applicationWillEnterForeground:(UIApplication *)application{
    // 结束 &  失效后台任务
    [self endAndInvalidBackgroundTask];
}


// 开启后台任务
-(void)beginBackgroundTask{
    // 申请后台任务(一般为3分钟)
    __weak typeof(self) weakSelf = self;
       _bgTask= [[UIApplication sharedApplication]  beginBackgroundTaskWithExpirationHandler:^{
           /**
            当你想app申请的后台任务时间快结束了, 就会回调这个block块, 你需要在这个blcok内做一些
            清理收尾方面的工作, 否则可能会导致程序出错.
            这个block 会在主线程调用, 因此你可以在这个block内放心大胆的处理你的收尾工作
            */
           
           NSLog(@"申请的后台任务时间 快结束了, 赶紧在这个block内处理你的收尾工作, %@",[NSThread currentThread]);
           [weakSelf endAndInvalidBackgroundTask];
       }];
}

// 结束 &  失效后台任务
-(void)endAndInvalidBackgroundTask{
    //app从后台返回前台时, 如果申请的后台任务还没结束, 需要结束后台任务
    if (_bgTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:_bgTask];
        _bgTask  = UIBackgroundTaskInvalid;
    }
}

@end
