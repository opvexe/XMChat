//
//  ChatVideoMessageCell.h
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ChatMessageCell.h"


/**
 * 视频消息
 ***
 */
@interface ChatVideoMessageCell : ChatMessageCell

/**
 * 上传视频进度

 @param uploadProgress uploadProgress description
 */
- (void)setUploadProgress:(CGFloat)uploadProgress;
@end
