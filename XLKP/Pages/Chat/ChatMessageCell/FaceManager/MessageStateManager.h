//
//  MessageStateManager.h
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ChatUntiles.h"

@interface MessageStateManager : NSObject

+ (instancetype)shareManager;

#pragma mark - 公有方法

/**
 * 消息发送状态

 @param index index description
 @return return value description
 */
- (MessageSendState)messageSendStateForIndex:(NSUInteger)index;


/**
 * 消息阅读状态

 @param index index description
 @return return value description
 */
- (MessageReadState)messageReadStateForIndex:(NSUInteger)index;


/**
 * 设置消息发送状态

 @param messageSendState messageSendState description
 @param index index description
 */
- (void)setMessageSendState:(MessageSendState)messageSendState forIndex:(NSUInteger)index;


/**
 * 设置消息阅读状态

 @param messageReadState messageReadState description
 @param index index description
 */
- (void)setMessageReadState:(MessageReadState)messageReadState forIndex:(NSUInteger)index;


/**
 * 清除消息状态
 */
- (void)cleanState;

@end

