//
//  ChatMessageCell+CellIdentifier.m
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ChatMessageCell+CellIdentifier.h"

@implementation ChatMessageCell (CellIdentifier)

+ (NSString *)cellIdentifierForMessageConfiguration:(NSDictionary *)messageConfiguration{
    
    MessageType messageType   = [messageConfiguration[kMessageConfigurationTypeKey] integerValue];
    MessageOwner messageOwner = [messageConfiguration[kMessageConfigurationOwnerKey] integerValue];
    MessageChat messageChat   = [messageConfiguration[kMessageConfigurationGroupKey] integerValue];
    NSString *strIdentifierKey   = @"ChatMessageCell";
    NSString *strOwnerKey;
    NSString *strTypeKey;
    NSString *strGroupKey;

    ///MARK: 消息是发送方还是接收方
    switch (messageOwner){
        case MessageOwnerSystem:
            strOwnerKey = @"OwnerSystem";
            break;
        case MessageOwnerOther:
            strOwnerKey = @"OwnerOther";
            break;
        case MessageOwnerSelf:
            strOwnerKey = @"OwnerSelf";
            break;
        default:
            NSAssert(NO, @"Message Owner Unknow");
            break;
    }
    
    /// MARK: 消息类型
    switch (messageType){
        case MessageTypeVoice:
            strTypeKey = @"VoiceMessage";
            break;
        case MessageTypeImage:
        case MessageTypeGifImage:
            strTypeKey = @"ImageMessage";
            break;
        case MessageTypeVideo:
            strTypeKey = @"VideoMessage";
            break;
        case MessageTypeLocation:
            strTypeKey = @"LocationMessage";
            break;
        case MessageTypeDateTime:
            strTypeKey = @"DateTimeMessage";
            break;
        case MessageTypeText:
            strTypeKey = @"TextMessage";
            break;
        case MessageTypeVoiceCall:              ///视频通话，声音通话
        case MessageTypeVideoCall:
            strTypeKey = @"CallMessage";
            break;
        default:
            NSAssert(NO, @"Message Type Unknow");
            break;
    }
    
    ///MARK:聊天类型
    switch (messageChat){
        case MessageChatGroup:
            strGroupKey = @"GroupCell";
            break;
        case MessageChatSingle:
            strGroupKey = @"SingleCell";
            break;
            case MessageChatSystem:
             strGroupKey = @"SystemCell";
            break;
        default:
            strGroupKey = @"";
            break;
    }
    NSLog(@"CellIdentifier:%@",[NSString stringWithFormat:@"%@_%@_%@_%@",strIdentifierKey,strOwnerKey,strTypeKey,strGroupKey]);
    return  [NSString stringWithFormat:@"%@_%@_%@_%@",strIdentifierKey,strOwnerKey,strTypeKey,strGroupKey];
}
@end
