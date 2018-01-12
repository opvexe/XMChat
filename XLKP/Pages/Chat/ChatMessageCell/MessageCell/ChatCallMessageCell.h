//
//  ChatCallMessageCell.h
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ChatMessageCell.h"


/**
 * 视频聊天消息
 **
 */
@interface ChatCallMessageCell : ChatMessageCell

@property (nonatomic, assign) BOOL isVideoCall;

@end
