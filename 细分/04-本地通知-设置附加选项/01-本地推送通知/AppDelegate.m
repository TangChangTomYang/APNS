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
    NSLog(@"app 接收到本地推送通知, userinfo: %@", notification.userInfo);
    
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
 

// 处理本地通知, 用户的交互 (8.0 这个)
//-(void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(nonnull UILocalNotification *)notification completionHandler:(nonnull void (^)(void))completionHandler{
//
//    NSLog(@"-------8.0");
//}

// 处理本地通知, 用户的交互(9.0 这个)
-(void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(nonnull UILocalNotification *)notification withResponseInfo:(nonnull NSDictionary *)responseInfo completionHandler:(nonnull void (^)(void))completionHandler{
    
    NSLog(@"identifier--------%@", identifier);
    if([identifier isEqualToString:@"send_msg_notice_sendMsg"]){
        NSLog(@"用户要求 回消息: ");
        NSLog(@"%@", [responseInfo description]);
        NSLog(@"%@", [notification.userInfo description]);
    }
    else if([identifier isEqualToString:@"send_msg_notice_cancle"]){
        NSLog(@"用户 选择不回消息");
    }
    
    
    
    completionHandler();
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


-(UIUserNotificationCategory *)inputCategory{
    // 从iOS8.0开始, 可以为本地推送通知添加 附加操作(可以在横幅上增加按钮, 输入框等), 通过UIUserNotificationCategory 来设置
    // 每一个UIUserNotificationCategory 表示的就是一组操作
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"send_msg_notice";
    
    //  创建 行为
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc]init];
    // 行为的标识, 用来区分用户点击的是哪一个行为
    action1.identifier = @"send_msg_notice_sendMsg";
    action1.title = @"发送消息"; // 行为的名称
    
    // 行为的环境
    // UIUserNotificationActivationModeForeground 意味着用户点击了这个按钮就会进入前台, 来执行相应的操作
    // UIUserNotificationActivationModeBackground 意味着在后台就可以执行这个行为
    action1.activationMode = UIUserNotificationActivationModeForeground;
    
    // 设置是否必须解锁才能用
    action1.authenticationRequired = true; // 如果action.activationMode设置的是前台, 这个属性会被忽略
    
    // 设置是否是一个破坏行为(通过一些颜色, 来标识按钮, 警醒用户)
    action1.destructive = YES;
    
    // 修改行为的样式
    // UIUserNotificationActionBehaviorDefault,
    // UIUserNotificationActionBehaviorTextInput
    action1.behavior = UIUserNotificationActionBehaviorTextInput;  // iOS9  支持
    
    // 设置行为的参数 (这个就是 按钮的标题)
    action1.parameters = @{UIUserNotificationTextInputActionButtonTitleKey : @"点击发消息我"};
    
    
    
    //  创建 行为
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc]init];
    // 行为的标识, 用来区分用户点击的是哪一个行为
    action2.identifier = @"send_msg_notice_cancle";
    action2.title = @"取消"; // 行为的名称
    
    // 行为的环境
    // UIUserNotificationActivationModeForeground 意味着用户点击了这个按钮就会进入前台, 来执行相应的操作
    // UIUserNotificationActivationModeBackground 意味着在后台就可以执行这个行为
    action2.activationMode = UIUserNotificationActivationModeBackground;
    
    // 设置是否必须解锁才能用
    action2.authenticationRequired = false; // 如果action.activationMode设置的是前台, 这个属性会被忽略
    
    // 设置是否是一个破坏行为(通过一些颜色, 来标识按钮, 警醒用户)
    action2.destructive = NO;
     
    NSArray<UIMutableUserNotificationAction *> *actions = @[action1, action2] ;
     
    // UIUserNotificationActionContextDefault 最多设置4个自定义选项
    // UIUserNotificationActionContextMinimal 最多设置2个自定义选项
    [category setActions:actions forContext:UIUserNotificationActionContextDefault];
     
    return category;
}


-(UIUserNotificationCategory *)chooseCategory{
    // 从iOS8.0开始, 可以为本地推送通知添加 附加操作(可以在横幅上增加按钮, 输入框等), 通过UIUserNotificationCategory 来设置
    // 每一个UIUserNotificationCategory 表示的就是一组操作
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"Yes_or_no_notice";
    
    //  创建 行为
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc]init];
    // 行为的标识, 用来区分用户点击的是哪一个行为
    action1.identifier = @"Yes_or_no_notice_chooseYes";
    action1.title = @"我同意"; // 行为的名称
    
    // 行为的环境
    // UIUserNotificationActivationModeForeground 意味着用户点击了这个按钮就会进入前台, 来执行相应的操作
    // UIUserNotificationActivationModeBackground 意味着在后台就可以执行这个行为
    action1.activationMode = UIUserNotificationActivationModeForeground;
    
    // 设置是否必须解锁才能用
    action1.authenticationRequired = true; // 如果action.activationMode设置的是前台, 这个属性会被忽略
    
    // 设置是否是一个破坏行为(通过一些颜色, 来标识按钮, 警醒用户)
    action1.destructive = YES;
    
    
    
    //  创建 行为
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc]init];
    // 行为的标识, 用来区分用户点击的是哪一个行为
    action2.identifier = @"Yes_or_no_notice_chooseNo";
    action2.title = @"我不同意"; // 行为的名称
    
    // 行为的环境
    // UIUserNotificationActivationModeForeground 意味着用户点击了这个按钮就会进入前台, 来执行相应的操作
    // UIUserNotificationActivationModeBackground 意味着在后台就可以执行这个行为
    action2.activationMode = UIUserNotificationActivationModeBackground;
    
    // 设置是否必须解锁才能用
    action2.authenticationRequired = false; // 如果action.activationMode设置的是前台, 这个属性会被忽略
    
    // 设置是否是一个破坏行为(通过一些颜色, 来标识按钮, 警醒用户)
    action2.destructive = NO;
     
    NSArray<UIMutableUserNotificationAction *> *actions = @[action1, action2] ;
     
    // UIUserNotificationActionContextDefault 最多设置4个自定义选项
    // UIUserNotificationActionContextMinimal 最多设置2个自定义选项
    [category setActions:actions forContext:UIUserNotificationActionContextDefault];
     
    return category;
}


// 注册本地推送t通知
-(void)registLocalNotice{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        // types 是用来设置通知的类型的
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge;
        
        

        
        NSSet<UIUserNotificationCategory *> *categorySet = [NSSet setWithArray:@[[self chooseCategory], [self inputCategory]]] ;
        
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:types
                                                                                categories:categorySet];
        [[UIApplication sharedApplication ] registerUserNotificationSettings:setting];
    }
}




/*-----后台任务------------------------------------------*/
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
