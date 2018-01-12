//
//  AppDelegate+Category.m
//  XLIM
//
//  Created by Facebook on 2017/11/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "AppDelegate+Category.h"
#import "XLTabBarViewController.h"

@implementation AppDelegate (Category)
/**
 * 初始化IMSDK
 ***
 */
-(void)initWithIMSDK{
    TIMManager *manager = [TIMManager sharedInstance];
    [manager setEnv:TIM_ENV];
    TIMSdkConfig *config = [[TIMSdkConfig alloc] init];
    config.sdkAppId = [TIM_SDKAppId intValue] ;
    config.accountType = TIM_SDKAccountType;
    config.disableCrashReport = NO;
    config.connListener = self;
    [manager initSdk:config];
    
    TIMUserConfig *userConfig = [[TIMUserConfig alloc] init];
     userConfig.disableRecnetContact = NO;
    userConfig.disableRecentContactNotify = YES;
     userConfig.disableRecentContactNotify = YES;//不通过onNewMessage:抛出最新联系人的最后一条消息（加载消息扩展包有效）
    userConfig.userStatusListener = self;           ///监听用户状态
//     userConfig.refreshListener = self;           ///刷新会话
    userConfig.disableAutoReport = YES;
    [manager setUserConfig:userConfig];

    ///MARK:设置自动登录
    [self setAutoLogin];
    
}


/**
 *  设置自动登录
 ***
 */
-(void)setAutoLogin{
    TLSHelper *helper = [TLSHelper getInstance];
    TLSUserInfo *userInfo = [helper getLastUserInfo];
    BOOL login = [helper needLogin:userInfo.identifier];
    if (login) {
        NSLog(@"自动登录成功 -- ");
    }else{
        NSLog(@"自动登录失败");
        TIMLoginParam *login = [[TIMLoginParam alloc]init];
        login.identifier = userInfo.identifier;
        login.appidAt3rd = TIM_SDKAppId;
        login.userSig = [[TLSHelper getInstance] getTLSUserSig:userInfo.identifier];
        [[TIMManager sharedInstance]login:login succ:^{
            NSLog(@"IM登录成功");
            self.window.rootViewController = [XLTabBarViewController  new];
        } fail:^(int code, NSString *msg) {
            NSLog(@"IM登录失败:%@",msg);
        }];
    }
}
#pragma mark -<TIMConnListener>
/**
 *  网络连接成功
 */
- (void)onConnSucc{
    
    NSLog(@"网络连接成功");
}

/**
 *  网络连接失败
 *
 *  @param code 错误码
 *  @param err  错误描述
 */
- (void)onConnFailed:(int)code err:(NSString*)err{
    NSLog(@"网络连接失败");
}

/**
 *  网络连接断开（断线只是通知用户，不需要重新登陆，重连以后会自动上线）
 *
 *  @param code 错误码
 *  @param err  错误描述
 */
- (void)onDisconnect:(int)code err:(NSString*)err{
    NSLog(@"网络连接断开");
}


/**
 *  连接中
 */
- (void)onConnecting{
    NSLog(@"连接中");
}


#pragma mark <TIMUserStatusListener>
/**
 *  踢下线通知
 */
- (void)onForceOffline{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:
                          @"您的帐号在别的设备上登录，"
                          @"您被迫下线！"
                          delegate:nil
                          cancelButtonTitle:@"知道了"
                          otherButtonTitles:nil, nil];
    [alert show];
}

/**
 *  断线重连失败
 */
- (void)onReConnFailed:(int)code err:(NSString*)err{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"下线通知"
                          message:
                          @"断线重连失败，"
                          delegate:nil
                          cancelButtonTitle:@"退出"
                          otherButtonTitles:@"重新登录", nil];
    [alert show];
}

/**
 *  用户登录的userSig过期（用户需要重新获取userSig后登录）
 */
- (void)onUserSigExpired{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"下线通知"
                          message:
                          @"userSig过期"
                          delegate:nil
                          cancelButtonTitle:@"重新登录"
                          otherButtonTitles:nil, nil];
    [alert show];
}

@end
