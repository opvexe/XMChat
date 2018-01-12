//
//  ChatImageMessageCell.h
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ChatMessageCell.h"


/**
 *  图片消息
 ***
 */
@interface ChatImageMessageCell : ChatMessageCell


/**
 * 上传图片进度

 @param uploadProgress uploadProgress description
 */
- (void)setUploadProgress:(CGFloat)uploadProgress;

@end
