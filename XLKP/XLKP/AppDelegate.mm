//
//  AppDelegate.m
//  XLKP
//
//  Created by Facebook on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "AppDelegate.h"
#import "XLLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self initWithIMSDK];

//    self.window.rootViewController = [XLLoginViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    __block UIBackgroundTaskIdentifier bgTaskID;
    bgTaskID = [application beginBackgroundTaskWithExpirationHandler:^ {
        [application endBackgroundTask: bgTaskID];
        bgTaskID = UIBackgroundTaskInvalid;
    }];
    
    TLSUserInfo *user = [[TLSUserInfo alloc]init];      ///本地取出TLSUserInfo
    TIMConversation *conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:user.identifier];
    int unreadMsg =  [conversation getUnReadMessageNum];
    TIMBackgroundParam  *param = [[TIMBackgroundParam alloc] init];
    [param setC2cUnread:(int)unreadMsg];
    [[TIMManager sharedInstance] doBackground:param succ:^() {
        NSLog(@"进入后台成功");
    } fail:^(int code, NSString * err) {
        NSLog(@"进入后台失败");
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [UIApplication.sharedApplication.windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *w, NSUInteger idx, BOOL *stop) {
        if (!w.opaque && [NSStringFromClass(w.class) hasPrefix:@"UIText"]) {
            BOOL wasHidden = w.hidden;
            w.hidden = YES;
            w.hidden = wasHidden;
            *stop = YES;
        }
    }];
    ///MARK: 清空消息栏
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[TIMManager sharedInstance] doForeground:^{
        NSLog(@"切前台 成功");
    } fail:^(int code, NSString *msg) {
        NSLog(@"切前台 失败");
    }];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark  APNS
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@", error.localizedDescription);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"userinfo:%@",userInfo);
    NSLog(@"收到推送消息:%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
}

-(void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    [[TIMManager sharedInstance] log:TIM_LOG_INFO tag:@"XLToken" msg:[NSString stringWithFormat:@"APNSToken:%@",token]];
    TIMTokenParam *param = [[TIMTokenParam alloc] init];
    param.busiId = 2383;
    [param setToken:deviceToken];
    [[TIMManager sharedInstance] setToken:param succ:^{
        NSLog(@"APNS_TOKEN上传成功");
    } fail:^(int code, NSString *msg) {
        NSLog(@"APNS_TOKEN上传失败");
    }];
}

@end
