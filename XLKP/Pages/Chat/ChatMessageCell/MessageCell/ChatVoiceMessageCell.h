//
//  ChatVoiceMessageCell.h
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ChatMessageCell.h"


/**
 *  录音消息
 ***
 */
@interface ChatVoiceMessageCell : ChatMessageCell


/**
 设置录音状态
 */
@property (nonatomic, assign) VoiceMessageState voiceMessageState;

@end
