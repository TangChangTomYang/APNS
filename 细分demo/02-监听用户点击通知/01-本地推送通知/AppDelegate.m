//
//  AppDelegate.m
//  01-本地推送通知
//
//  Created by yangrui on 2020/3/8.
//  Copyright © 2020 yangrui. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()


 
@property(nonatomic, strong)NSDictionary *info;
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
    
   if(launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]){
        // 用户点击本地推送通知, 启动的app
        // 需要在这里处理, 点击本地通知后的 相应的处理逻辑
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 150)];
        lb.backgroundColor = [UIColor orangeColor];
        lb.text = [launchOptions[UIApplicationLaunchOptionsLocalNotificationKey] description];
        [self.window.rootViewController.view addSubview:lb];
        
    }
    
    
    
    return YES;
}


/**
 当app接收到本地推送通知并满足以下条件, 就会调用
 1. 当app在前台时接收到通知, 会立即调用此方法
 2. app在后台, 用户点击了通知横幅进入前台后, 会立即调用此方法 (先调进入前台, 再调收到通知)
 3. 锁屏状态下, 用户点击了横幅, 会立即调用此方法 (先调收到通知, 再调进入前台)
 4. 当程序完全退出后, 用户点击通知横幅不会触发这个方法的回调.
 */
- (void)application:(UIApplication *)app didReceiveLocalNotification:(nonnull UILocalNotification *)notification{
    NSLog(@"app 接收到本地推送通知");
    
    if (app.applicationState  == UIApplicationStateActive ) { // app  在前台时接收到通知
        
        NSLog(@"UIApplicationStateActive");
        // app此时在前台, 只需更新用户消息数量, 不需要跳转页面
    }
    else if (app.applicationState  == UIApplicationStateInactive ) { // app 在后台时 用户点击通知
       NSLog(@"UIApplicationStateInactive");
        // app 从后台进入到前台, 这时可以跳转页面
    }
    else if (app.applicationState  == UIApplicationStateBackground ) { //  app 在锁屏时, 用户点击本地通知打开app
        NSLog(@"UIApplicationStateBackground");
    }
}
 
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSLog(@"----app 进入后台");
    // 开启后台任务
    [self beginBackgroundTask];
}

-(void)applicationWillEnterForeground:(UIApplication *)application{
    NSLog(@"----app 进入前台");
    // 结束 &  失效后台任务
    [self endAndInvalidBackgroundTask];
}

/// 本地推送通知相关


// 注册本地推送t通知
-(void)registLocalNotice{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication ] registerUserNotificationSettings:setting];
    }
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
