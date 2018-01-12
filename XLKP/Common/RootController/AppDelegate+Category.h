//
//  AppDelegate+Category.h
//  XLIM
//
//  Created by Facebook on 2017/11/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Category)<TIMConnListener,TIMUserStatusListener,TIMRefreshListener>

-(void)initWithIMSDK;

@end
