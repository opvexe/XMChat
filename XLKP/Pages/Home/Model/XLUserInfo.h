//
//  XLUser.h
//  XLKP
//
//  Created by Facebook on 2017/11/22.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 用户信息类
 */
@interface XLUserInfo : NSObject<NSCopying>

/*!
 用户ID
 */
@property(nonatomic, strong) NSString *userId;

/*!
 用户名称
 */
@property(nonatomic, strong) NSString *name;

/*!
 用户头像的URL
 */
@property(nonatomic, strong) NSString *portraitUri;

/*!
 用户备注
 */
@property (nonatomic, copy) NSString *remark;
/*!
 用户信息的初始化方法
 
 @param userId      用户ID
 @param username    用户名称
 @param portrait    用户头像的URL
 @return            用户信息对象
 */
- (instancetype)initWithUserId:(NSString *)userId
                          name:(NSString *)username
                      portrait:(NSString *)portrait
                        remark:(NSString *)remark;
@end
