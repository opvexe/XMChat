//
//  XLLoginViewController.m
//  XLIM
//
//  Created by Facebook on 2017/11/17.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "XLLoginViewController.h"
#import "XLConversationListViewController.h"
@interface XLLoginViewController ()<TLSStrAccountRegListener,TLSPwdLoginListener>

@end

@implementation XLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self IM_RegisterAccount:@"taoshumin22" withPassword:@"11111111"];
    [self IM_LoginAccount:@"taoshumin22" withPassword:@"11111111"];
}


#pragma mark   -- 注册 -- <TLSStrAccountRegListener>

/**
 * 注册 字符串帐号注册
 
 @param account account description
 @param password password description
 */
-(void)IM_RegisterAccount:(NSString *)account withPassword:(NSString *)password{
    [[TLSHelper getInstance]TLSStrAccountReg:account andPassword:password andTLSStrAccountRegListener:self];
}


/**
 * 注册成功
 
 @param userInfo userInfo description
 */
-(void)OnStrAccountRegSuccess:(TLSUserInfo*)userInfo{
    NSLog(@"注册成功");
}

/**
 *  注册失败
 *
 *  @param errInfo 错误信息
 */
-(void)OnStrAccountRegFail:(TLSErrInfo *) errInfo{
    NSLog(@"注册失败");
}

/**
 *  注册超时
 *
 *  @param errInfo 错误信息
 */
-(void)OnStrAccountRegTimeout:(TLSErrInfo *) errInfo{
    NSLog(@"注册超时");
}

#pragma mark - 登录 -- <TLSPwdLoginListener>
/**
 * 登录 账号
 
 @param account account description
 @param password password description
 */
-(void)IM_LoginAccount:(NSString *)account withPassword:(NSString *)password{
    WS(weakSelf)
    [[TLSHelper getInstance]TLSPwdLogin:account andPassword:password andTLSPwdLoginListener:weakSelf];
}

/**
 * 登录成功
 
 @param userInfo userInfo description
 */
-(void)OnPwdLoginSuccess:(TLSUserInfo *)userInfo{
    TIMLoginParam *login = [[TIMLoginParam alloc]init];
    login.identifier = userInfo.identifier;
    login.appidAt3rd = TIM_SDKAppId;
    login.userSig = [[TLSHelper getInstance] getTLSUserSig:userInfo.identifier];
    [[TIMManager sharedInstance]login:login succ:^{
        NSLog(@"IM登录成功");
    [self presentViewController:[XLConversationListViewController new] animated:YES completion:nil];
    } fail:^(int code, NSString *msg) {
        NSLog(@"IM登录失败:%@",msg);
    }];
}


/**
 * 登录失败
 
 @param errInfo errInfo description
 */
-(void)OnPwdLoginFail:(TLSErrInfo *)errInfo{
    NSLog(@"登录失败:%@",errInfo);
}


/**
 * 登录超时
 
 @param errInfo errInfo description
 */
-(void)OnPwdLoginTimeout:(TLSErrInfo *)errInfo{
    NSLog(@"登录超时");
}


@end

