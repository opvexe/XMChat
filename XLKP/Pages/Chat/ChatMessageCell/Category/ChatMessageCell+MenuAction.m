//
//  ChatMessageCell+MenuAction.m
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ChatMessageCell+MenuAction.h"
#import <objc/runtime.h>

NSString * const kChatMessageCellMenuControllerKey;

@implementation ChatMessageCell (MenuAction)

#pragma mark - 私有方法

//以下两个方法必须有
/*
 *  让UIView成为第一responser
 */
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

/*
 *  根据action,判断UIMenuController是否显示对应aciton的title
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if ((action == @selector(menuRelayAction)) ||
        (action == @selector(menuDeleteAction))||
        (action == @selector(menuCopyAction)))
    {
        return YES;
    }
    
    return NO;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGes
{
    if (longPressGes.state == UIGestureRecognizerStateBegan)
    {
        CGPoint longPressPoint = [longPressGes locationInView:self.contentView];
        if (!CGRectContainsPoint(self.messageContentView.frame, longPressPoint))
        {
            return;
        }
        [self becomeFirstResponder];
        //!!!此处使用self.superview.superview 获得到cell所在的tableView,不是很严谨
        CGRect targetRect = [self convertRect:self.messageContentView.frame toView:self.superview.superview];
        [self.menuController setTargetRect:targetRect inView:self.superview.superview];
        [self.menuController setMenuVisible:YES animated:YES];
    }
}


- (void)menuCopyAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCell:withActionType:)])
    {
        [self.delegate messageCell:self withActionType: ChatMessageCellMenuActionTypeCopy];
    }
}

- (void)menuDeleteAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCell:withActionType:)])
    {
        [self.delegate messageCell:self withActionType: ChatMessageCellMenuActionTypeDelete];
    }
}

- (void)menuRelayAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCell:withActionType:)])
    {
        [self.delegate messageCell:self withActionType: ChatMessageCellMenuActionTypeRelay];
    }
}

#pragma mark - Getters方法
- (UIMenuController *)menuController
{
    UIMenuController *menuController = objc_getAssociatedObject(self,&kChatMessageCellMenuControllerKey);
    if (!menuController)
    {
        menuController = [UIMenuController sharedMenuController];
        UIMenuItem *copyItem   = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopyAction)];
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menuDeleteAction)];
        UIMenuItem *shareItem  = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(menuRelayAction)];
        
        if ((MessageTypeText == self.messageType)  ||
            (MessageTypeVideo == self.messageType) ||
            (MessageTypeImage == self.messageType))
        {
            [menuController setMenuItems:@[copyItem,deleteItem,shareItem]];
        }
        else
        {
            [menuController setMenuItems:@[deleteItem,shareItem]];
        }
        [menuController setArrowDirection:UIMenuControllerArrowDown];
        objc_setAssociatedObject(self, &kChatMessageCellMenuControllerKey, menuController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return menuController;
}

@end
