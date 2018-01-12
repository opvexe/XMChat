//
//  XLConversationModel.h
//  XLIM
//
//  Created by Facebook on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "WY_BaseModel.h"

@interface XLConversationModel : WY_BaseModel

@property(nonatomic,copy) NSString *nickname;   //名字
@property (nonatomic,copy) NSString *head_img;  //头像
@property (nonatomic,copy) NSString *signature; //消息
@property (nonatomic,copy) NSString *remark;    //备注
@property (nonatomic,copy) NSString *badgeValue;//未读消息数
@property (nonatomic,copy) NSString *updated_at;//消息时间

@property (nonatomic,assign) NSUInteger rowHeight;


@end
