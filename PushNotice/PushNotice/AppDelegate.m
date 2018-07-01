//
//  AppDelegate.m
//  PushNotice
//
//  Created by yangrui on 2018/7/1.
//  Copyright © 2018年 yangrui. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


/** 创建一个选择 选项组 */
-(UIMutableUserNotificationCategory *)selectCategory{
    
    UIMutableUserNotificationAction *selectAction1 = [[UIMutableUserNotificationAction alloc]init];
    selectAction1.identifier =  @"Foreground";
    selectAction1.title = @"前台操作";
    // UIUserNotificationActivationModeForeground 表示用户点击的操作就会进入到前台 来执行相应的行为
    selectAction1.activationMode = UIUserNotificationActivationModeForeground;
    // 设置是否必须解锁才能完成操作
    selectAction1.authenticationRequired = YES; // 是否需要解锁权限来完成(UIUserNotificationActivationModeForeground 模式不需要)
   // 设置是否是一个破坏性行为(即通过一些颜色来表示按钮)
    selectAction1.destructive = YES;
    // 设置操作的样式
    selectAction1.behavior = UIUserNotificationActionBehaviorDefault;
    
    
    UIMutableUserNotificationAction *selectAction2 = [[UIMutableUserNotificationAction alloc]init];
    selectAction2.identifier =  @"Background";
    selectAction2.title = @"后台操作";
    selectAction2.activationMode = UIUserNotificationActivationModeBackground;
    // 设置是否必须解锁才能完成操作
    selectAction2.authenticationRequired = YES; // 是否需要解锁权限来完成(UIUserNotificationActivationModeForeground 模式不需要)
    // 设置操作的样式
    selectAction2.behavior = UIUserNotificationActionBehaviorTextInput;  // 输入框
    selectAction2.parameters = @{UIUserNotificationTextInputActionButtonTitleKey: @"后台操作"}; // 输入框的标题

    
    // 创建一个操作选项组
    UIMutableUserNotificationCategory *selectCategory = [[UIMutableUserNotificationCategory alloc] init];
    selectCategory.identifier = @"selectCategory";
    [selectCategory  setActions:@[selectAction1,selectAction2 ] forContext:UIUserNotificationActionContextDefault];
   
    
    return selectCategory;
}

/** 注册通知 ios 8.0之后才需要  */
-(void) registUsrNotificantion{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        //1. 这定义通知选项类别功能(每一个类别就对应一个类型的操作)
        NSSet *categorySet = [NSSet setWithObjects:[self selectCategory], nil];
        
        //2. 设置通知的类型 和 通知的自定义选项类别
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:categorySet];
        
        //3. 注册本地通知
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
        
        //4. 注册远程推送通知,
        //   这个方法会自动获取设备的UDID 和 app 的bundleId 并给苹果的服务器发送请求获取DeviceToken
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
}

-(void)sendLocalNotice{
    // 创建本地通知
    UILocalNotification *localNotice = [[UILocalNotification alloc]init];
    // 设置本地通知消息体
    localNotice.alertBody = @"有短消息了";
    // 设置本地通知触发时间
    localNotice.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    
    
    // 因为发送推送通知是系统级别的事情,因次需要用Application  来执行
    // 立即发送通知
    // [[UIApplication sharedApplication] presentLocalNotificationNow:localNotice];
    
    // 根据通知设置的触发时间发送通知
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotice];
    
}

/** 本地推送通知的使用
 1、创建UILocalNotification对象
 2、设置一些必要的参数
 3、开始推送通知
 4、取消调度本地推送通知
 5、获得被调度(定制)的所有本地推送通知
 6、注意事项
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self registUsrNotificantion];
    
    // launchOptions 启动字典
    // 一般通过其他方式启动(非点击应用图标启动)app,都会把一些需要传递的参数,放到这个字典中
    NSString *des = launchOptions.description;
 
    if (des.length > 0) {
        [des writeToFile:@"/Users/yang/Desktop/abc.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        
    }
    /**
     
     {
     UIApplicationLaunchOptionsLocalNotificationKey = "<UIConcreteLocalNotification: 0x60400019b930>
     
     {fire date = Sunday,  July 1, 2018 at 4:24:12 PM China Standard Time,
     time zone = (null),
     repeat interval = 0, repeat count = UILocalNotificationInfiniteRepeatCount, next fire date = (null), user info = {\n}}";
     }
     */
   

    return YES;
}





-(void)applicationDidBecomeActive:(UIApplication *)application{
    // 在这个地方清除 应用的消息数
    application.applicationIconBadgeNumber = 0;
    
}




/** (本地通知)当接收到通知,且满足以下3种情况中的一种时,会调用此方法
 1: 当 app 在前台
 2: 在后台,用户点击了通知
 3: 在锁屏状态, 用户点击了通知
 */
-(void)application:(UIApplication *)app didReceiveLocalNotification:(nonnull UILocalNotification *)notification{
    
    if (app.applicationState == UIApplicationStateActive) {
         NSLog(@"---app在前台时--------接收到通知");
    }
    else  if (app.applicationState == UIApplicationStateInactive) {
         NSLog(@"---app在后台时--------接收到通知");
    }
}

/** 9.0 之前用这个  */
-           (void)application:(UIApplication *)application
   handleActionWithIdentifier:(nullable NSString *)identifier
forLocalNotification:(nonnull UILocalNotification *)notification
         completionHandler:(nonnull void (^)())completionHandler{
    
    // 系统回调必须要执行一次
    completionHandler();
}

/** 9.0 之后用这个
 当用户点击了通知上的自动一按钮操作就会来到这个方法*/
-           (void)application:(UIApplication *)application
   handleActionWithIdentifier:(nullable NSString *)identifier
         forLocalNotification:(nonnull UILocalNotification *)notification
             withResponseInfo:(nonnull NSDictionary *)responseInfo
            completionHandler:(nonnull void (^)())completionHandler{
    
    // 前台操作
    if([identifier isEqualToString: @"Foreground"]){
        
        NSLog(@"-----用户点击的是-前台操作按钮,responseInfo: %@",responseInfo.description);
    }
    else if( [identifier isEqualToString: @"Background"]){
        NSLog(@"-----用户点击的是-后台操作按钮,responseInfo: %@",responseInfo.description);
    }
    // 系统回调必须要执行一次
      completionHandler();
}

/**
{"aps":{"alert":"This is some fancy message.","badge":1}}
 */

/** 当获取到 注册远程推送通知 就会来到这个方法
 参数1:
 参数2:
 参数3:
 参数4:
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    
    NSLog(@"deviceToken: %@",deviceToken);
}
@end
