//
//  WY_BaseModel.h
//  XLIM
//
//  Created by Facebook on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, IMAMSGType) {
    EIMAMSG_Unknown = 1,        // 未知消息类型
    EIMAMSG_Text,               // 文本
    EIMAMSG_Image,              // 图片
    EIMAMSG_File,               // 文件
    EIMAMSG_Sound,              // 语音
    EIMAMSG_Face,               // 表情
    EIMAMSG_Location,           // 定位
    EIMAMSG_Video,              // 视频消息
    EIMAMSG_Custom,             // 自定义
    EIMAMSG_TimeTip,            // 时间提醒标签，不存在于IMSDK缓存的数据库中，业务动态生成
    EIMAMSG_GroupTips,          // 群提醒
    EIMAMSG_GroupSystem,        // 群系统消息
    EIMAMSG_SNSSystem,          // 关系链消息
    EIMAMSG_ProfileSystem,      // 资料变更消息
    EIMAMSG_InputStatus,        // 对方输入状态
    EIMAMSG_SaftyTip,           // 敏感词消息提醒标签，不存在缓存中，退出聊天界面再进入，则不存在了
    EIMAMSG_RevokedTip,         // 消息撤回
    EIMAMSG_Multi,              // 富文消息，后期所有聊天消息全部使用富文本显示
};

@interface WY_BaseModel : NSObject

/**
 * 消息类型
 */
@property(nonatomic,assign)IMAMSGType messageType;
/**
 类名
 **/
@property(nonatomic,copy)NSString *ClassName;

@property(nonatomic,assign)TIMConversationType coversationType;     //会话类型
@property(nonatomic,strong)TIMConversation *msgConv;        //会话对象
@end
