//
//  ChatUntiles.h
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#ifndef ChatUntiles_h
#define ChatUntiles_h

/**
 *  消息发送状态,自己发送的消息时有
 */
typedef NS_ENUM(NSUInteger, MessageSendState)
{
    MessageSendSuccess = 0,  /**< 消息发送成功 */
    MessageSendStateSending, /**< 消息发送中 */
    MessageSendFail,          /**< 消息发送失败 */
};

/**
 *  ChatMessageCell menu对应action类型
 */
typedef NS_ENUM(NSUInteger, ChatMessageCellMenuActionType)
{
    ChatMessageCellMenuActionTypeCopy,   /**< 复制 */
    ChatMessageCellMenuActionTypeRelay,  /**< 转发 */
    ChatMessageCellMenuActionTypeDelete, /**< 删除 */
};

/**
 *  消息拥有者类型
 */
typedef NS_ENUM(NSUInteger, MessageOwner)
{
    MessageOwnerUnknown = 0, /**< 未知的消息拥有者 */
    MessageOwnerSystem,      /**< 系统消息 */
    MessageOwnerSelf,        /**< 自己发送的消息 */
    MessageOwnerOther,       /**< 接收到的他人消息 */
};

/**
 *  消息类型
 */
typedef NS_ENUM(NSUInteger, MessageType)
{
    MessageTypeUnknow = 0, /**< 未知的消息类型 */
    MessageTypeDateTime ,  /**< 消息发生的日期时间Cell */
    MessageTypeText,       /**< 文本消息 */
    MessageTypeImage,      /**< 图片消息 */
    MessageTypeGifImage,   /**< Gif动画图片消息 */
    MessageTypeVideo,      /**< 视频消息 */
    MessageTypeVoice,      /**< 语音消息 */
    MessageTypeFile,       /**< 文件消息 */
    MessageTypeLocation,   /**< 地理位置消息 */
    MessageTypeVoiceCall,  /**< 音频呼叫 */
    MessageTypeVideoCall,  /**< 视频呼叫 */
};

/**
 *  消息聊天类型
 */
typedef NS_ENUM(NSUInteger, MessageChat)
{
    MessageChatSingle = 0, /**< 单人聊天,不显示nickname */
    MessageChatGroup,      /**< 群组聊天,显示nickname */
    MessageChatSystem,     /**< 系统消息,显示nickname */
};

/**
 *  消息读取状态,接收的消息时有
 */
typedef NS_ENUM(NSUInteger, MessageReadState)
{
    MessageUnRead = 0, /**< 消息未读 */
    MessageReading,   /**< 正在接收 */
    MessageReaded,     /**< 消息已读 */
};

/**
 *  录音消息的状态
 */
typedef NS_ENUM(NSUInteger, VoiceMessageState)
{
    VoiceMessageStateNormal,      /**< 未播放状态 */
    VoiceMessageStateDownloading, /**< 正在下载中 */
    VoiceMessageStatePlaying,     /**< 正在播放 */
    VoiceMessageStateCancel,      /**< 播放被取消 */
};

#pragma mark - Message 相关key值定义

/**
 *  消息类型的key
 */
static NSString *const kMessageConfigurationTypeKey = @"com.fritt.kMessageConfigurationTypeKey";
/**
 *  消息拥有者的key
 */
static NSString *const kMessageConfigurationOwnerKey = @"com.fritt.kMessageConfigurationOwnerKey";
/**
 *  消息群组类型的key
 */
static NSString *const kMessageConfigurationGroupKey = @"com.fritt.kMessageConfigurationGroupKey";

/**
 *  消息昵称类型的key
 */
static NSString *const kMessageConfigurationNicknameKey = @"com.fritt.kMessageConfigurationNicknameKey";

/**
 *  消息头像类型的key
 */
static NSString *const kMessageConfigurationAvatarKey = @"com.fritt.kMessageConfigurationAvatarKey";

/**
 *  消息阅读状态类型的key
 */
static NSString *const kMessageConfigurationReadStateKey = @"com.fritt.kMessageConfigurationReadStateKey";

/**
 *  消息发送状态类型的key
 */
static NSString *const kMessageConfigurationSendStateKey = @"com.fritt.kMessageConfigurationSendStateKey";

/**
 *  文本消息内容的key
 */
static NSString *const kMessageConfigurationTextKey = @"com.fritt.kMessageConfigurationTextKey";
/**
 *  图片消息内容的key
 */

static NSString *const kMessageConfigurationImageKey = @"com.fritt.kMessageConfigurationImageKey";
/**
 *  视频消息内容的key
 */

static NSString *const kMessageConfigurationVideoKey = @"com.fritt.kMessageConfigurationVideoKey";

/**
 *  视频消息封面的key
 */
static NSString *const kMessageConfigurationVideoCoverKey = @"com.fritt.kMessageConfigurationVideoCoverKey";

/**
 *  视频消息uuid的key
 */
static NSString *const kMessageConfigurationVideoUuidKey = @"com.fritt.kMessageConfigurationVideoUuidKey";

/**
 *  语音消息内容的key
 */

static NSString *const kMessageConfigurationVoiceKey = @"com.fritt.kMessageConfigurationVoiceKey";

/**
 *  语音消息时长key
 */
static NSString *const kMessageConfigurationVoiceSecondsKey = @"com.fritt.kMessageConfigurationVoiceSecondsKey";

/**
 *  地理位置消息内容的key
 */
static NSString *const kMessageConfigurationLocationKey = @"com.fritt.kMessageConfigurationLocationKey";

/**
 *  地理位置消息内容描述的key
 */
static NSString *const kMessageConfigurationLocationDescKey = @"com.fritt.kMessageConfigurationLocationDescKey";

/**
 *  文件消息内容key
 */
static NSString *const kMessageConfigurationFileKey = @"com.fritt.kMessageConfigurationFileKey";
/**
 *  文件消息大小key
 */
static NSString *const kMessageConfigurationFileSizeKey = @"com.fritt.kMessageConfigurationFileSizeKey";
/**
 *  文件消息名字key
 */
static NSString *const kMessageConfigurationFileNameKey = @"com.fritt.kMessageConfigurationFileNameKey";
#endif /* ChatUntiles_h */
