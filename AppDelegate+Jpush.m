//
//  AppDelegate+Jpush.m
//  YLHTools
//
//  Created by 张丽 on 2018/10/31.
//  Copyright © 2018年 ZL. All rights reserved.
//

#import "AppDelegate+Jpush.h"

#import "JPUSHService.h"
//#import "NSObject+commonuse.h"

#import <UserNotifications/UserNotifications.h>
@interface AppDelegate ()<JPUSHRegisterDelegate>
@end
@implementation AppDelegate (Jpush)
- (BOOL)Jpush_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [JPUSHService setLogOFF];//setDebugMode
    //推送配置，及注册服务
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //获取registrationID 项目服务器发推送需要
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        //upload registrationID to server
    }];
    
    //启动推送服务
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:isProduction];
    
    //根据APP启动参数，判断是否由推送消息唤醒APP，并对消息进行处理
    if (launchOptions) {
        NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
        if (remoteNotification) {
            
            //此处将推送消息保存在通知参数内。可在首页加载完成添加监听，实现跳转等操作。可能有更好的办法
            [self performSelector:@selector(sendNotificationInfoToHomeVC:) withObject:remoteNotification afterDelay:1];
        }
    }
    
    return YES;
}


#pragma mark    ---     注册deviceToken到JPUSHService
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //向JPUSHService 上传deviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"推送注册失败");
}

#pragma mark    ---     APP 前台运行/后台运行 收到消息都会先走此方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark    ---    程序前台运行中 调用此方法
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {

    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        //对消息进行处理  比如自定义弹框显示在当前window上面
//        NSLog(@"前台收到推送：%@",[self getCurrentWindow]);
        
        
        
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

#pragma mark    ---    程序在后台，点击消息 调用此方法
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {

    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        //对消息进行处理  比如从当前控制器 push or present
//        NSLog(@"通过消息APP从后台被唤醒：%@",[self getCurrentViewController]);
        
        
    }
    completionHandler();
}

#pragma mark    ---     app events
- (void)sendNotificationInfoToHomeVC:(id)dict {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SystemMsgCallApp" object:dict];
}


@end
