//
//  ChatMessageCell+MenuAction.h
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ChatMessageCell.h"

@interface ChatMessageCell (MenuAction)

/**
 *  复制，粘贴，转发
 **
 */
@property (nonatomic, strong, readonly) UIMenuController *menuController;


/**
 * 长按手势
 
 @param longPressGes longPressGes description
 */
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGes;
@end
