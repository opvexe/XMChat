//
//  ThreePartyKey.h
//  XLIM
//
//  Created by Facebook on 2017/11/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#ifndef ThreePartyKey_h
#define ThreePartyKey_h

///MARK: 腾讯云
#define TIM_ENV              0               ///默认0正事环境，1测试环境
#define TIM_SDKAppId         @"1400001533"
#define TIM_SDKAccountType   @"792"          ///账号类型


#define NYBUserDefault [NSUserDefaults standardUserDefaults]

/* 循环引用 */
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define WSSTRONG(strongSelf) __strong typeof(weakSelf) strongSelf = weakSelf;

#endif /* ThreePartyKey_h */
