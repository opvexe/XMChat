//
//  UITableView+Register.m
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "UITableView+Register.h"
#import "ChatMessageCell.h"
#import "ChatCallMessageCell.h"
#import "ChatTextMessageCell.h"
#import "ChatImageMessageCell.h"
#import "ChatVoiceMessageCell.h"
#import "ChatVideoMessageCell.h"
#import "ChatLocationMessageCell.h"
#import "ChatDateTimeMessageCell.h"

@implementation UITableView (Register)


- (void)registerChatMessageCellClass{
    
    ///MARK: 文本消息  
    [self registerClass:[ChatTextMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerSelf_TextMessage_GroupCell"];
    [self registerClass:[ChatTextMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerSelf_TextMessage_SingleCell"];
    [self registerClass:[ChatTextMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerOther_TextMessage_GroupCell"];
    [self registerClass:[ChatTextMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerOther_TextMessage_SingleCell"];

    ///MARK: 图片消息
    [self registerClass:[ChatImageMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerSelf_ImageMessage_GroupCell"];
    [self registerClass:[ChatImageMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerSelf_ImageMessage_SingleCell"];
    [self registerClass:[ChatImageMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerOther_ImageMessage_GroupCell"];
    [self registerClass:[ChatImageMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerOther_ImageMessage_SingleCell"];
    
    ///MARK: 声音消息
    [self registerClass:[ChatVoiceMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerSelf_VoiceMessage_GroupCell"];
    [self registerClass:[ChatVoiceMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerSelf_VoiceMessage_SingleCell"];
    [self registerClass:[ChatVoiceMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerOther_VoiceMessage_GroupCell"];
    [self registerClass:[ChatVoiceMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerOther_VoiceMessage_SingleCell"];
    
    ///MARK: 视频消息
    [self registerClass:[ChatVideoMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerSelf_VideoMessage_GroupCell"];
    [self registerClass:[ChatVideoMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerSelf_VideoMessage_SingleCell"];
    [self registerClass:[ChatVideoMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerOther_VideoMessage_GroupCell"];
    [self registerClass:[ChatVideoMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerOther_VideoMessage_SingleCell"];
    
    ///MARK: 定位消息
    [self registerClass:[ChatLocationMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerSelf_LocationMessage_GroupCell"];
    [self registerClass:[ChatLocationMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerSelf_LocationMessage_SingleCell"];
    [self registerClass:[ChatLocationMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerOther_LocationMessage_GroupCell"];
    [self registerClass:[ChatLocationMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerOther_LocationMessage_SingleCell"];
    
    ///MARK: 时间戳消息
    [self registerClass:[ChatDateTimeMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerSystem_DateTimeMessage_SingleCell"];
    [self registerClass:[ChatDateTimeMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerSystem_DateTimeMessage_GroupCell"];
    [self registerClass:[ChatDateTimeMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerOther_DateTimeMessage_GroupCell"];
    [self registerClass:[ChatDateTimeMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerOther_DateTimeMessage_SingleCell"];
    
    ///MARK: 视频，语音通话
    [self registerClass:[ChatCallMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerSelf_CallMessage_GroupCell"];
    [self registerClass:[ChatCallMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerSelf_CallMessage_SingleCell"];
    [self registerClass:[ChatCallMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerOther_CallMessage_GroupCell"];
    [self registerClass:[ChatCallMessageCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerOther_CallMessage_SingleCell"];
    
}
@end
