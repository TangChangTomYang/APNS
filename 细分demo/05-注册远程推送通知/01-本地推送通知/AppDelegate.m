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
   
    [self registRemoteNotice];
    
    
    
    return YES;
}




// 当注册远程推送通知成功, 并返回deviceToken 就会回调这个方法
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    
    // 将deviceToken  发送给自己的服务器
    NSLog(@"%@",deviceToken);
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


/*-----注册远程推送通知---------------------------------*/
/**
  注册远程推送通知主要做2步事情
  1. 设置通知的类型(type 和 category)
  2. 发送请求获取 deviceToken
 */
-(void)registRemoteNotice{
     
    /** 远程推送通知完整的过程

    1. 发送设备的UDID + 应用的BundleID 给APNS服务器
    2. 苹果加密生成一个deviceToken
    3. 发送当前用户的deviceToken和用户的标志(比如id或qq)给QQ服务器
    4. QQ服务器把 deviceToken  与 用户的ID(张三) 进行绑定存储 .
    5. 李四给张三发消息, 张三不在线, QQ服务器通过张三的ID去查找张三的deviceTToken信息
    6. QQ服务器通知 APNS devicetoken(张三映射的devicetoken) 李四给它发送消息了.
    7. APNS 通过deviceTToken 找到张三现在的设备并找到里面的QQ, 将李四的消息推送给 张三QQapp
    */



    /**
     开发iOS应用 推送功能, iOS端需要做的事
     1. 请求苹果 获取 deviceToken (deviceToken 可以找到设备 以及 设备内的 app)
        deviceToken 其实就是 UDID + bundleID的产物
     2. 得到苹果返回的deviceToken, 发送deviceToken给公司自己的服务器存储
     3. 监听用户对通知的点击

     */

    /**
     调试iOS的远程推送功能, 必备条件
     1. 真机
     2. 调试推送需要的证书文件
     3. aps_developement.cer 某台电脑就能调试某个app的推送服务
     4. iphone5_QQ.mobileprovision 某台电脑就能利用某台设备调试某个app
     */

    /**
     发布具有推送服务的app
     1. aps_production.cer 如果发布的程序中包含了推送服务, 就必须安装这个证书
     2. qq.mobileprovision: 某台电脑就能发布某个程序.
     */
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
         
       UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        // 注册通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
        
        // 我们需要发送一个请求,  获取当前的deviceTToken
        // 只要调用了以下方法, 系统会自动获取 bundleID + UDID发送请求, 不需要我们做任何事.
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }
    else{
        UIRemoteNotificationType types  =  UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |  UIRemoteNotificationTypeSound;
        
        // 我们需要发送一个请求,  获取当前的deviceTToken
        // 只要调用了以下方法, 系统会自动获取 bundleID + UDID发送请求, 不需要我们做任何事.
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
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
