//
//  ChatAVAudioPlayer.h
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "NSObject+CommonBlock.h"

/**
 * 声音播放类
 **
 */

#pragma mark  ====  录制播放类

@interface ChatAVAudioPlayer : NSObject

/**
 * 播放录音类单利
 
 @return return value description
 */
+ (instancetype)sharedInstance;

/**
 * 销毁
 **
 */
+ (void)destory;

/**
 * 播放录音NSData
 
 @param data data description
 @param completion completion description
 */
- (void)playWith:(NSData *)data finish:(CommonVoidBlock)completion;

/**
 * 播放录音 URL
 
 @param url url description
 @param completion completion description
 */
- (void)playWithUrl:(NSURL *)url finish:(CommonVoidBlock)completion;

/**
 * 停止播放
 **
 */
- (void)stopPlay;

@end
