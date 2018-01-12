//
//  ChatMessageCell.m
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ChatMessageCell.h"

@implementation ChatMessageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setup];
    }
    return self;
}

#pragma mark - 初始化方法

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

#pragma mark - 重写基类方法

- (void)updateConstraints{
    
    [super updateConstraints];
    if ((self.messageOwner == MessageOwnerSystem) ||
        (self.messageOwner == MessageOwnerUnknown))
    {
        return;
    }
    
    ///如果是消息发送方
    if (self.messageOwner == MessageOwnerSelf){
        
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make){
             make.right.equalTo(self.contentView.mas_right).with.offset(-16);
             make.top.equalTo(self.contentView.mas_top).with.offset(16);
             make.width.equalTo(@50);
             make.height.equalTo(@50);
         }];
        
        [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make){
             make.top.equalTo(self.headImageView.mas_top);
             make.right.equalTo(self.headImageView.mas_left).with.offset(-16);
             make.width.mas_lessThanOrEqualTo(@120);
             make.height.equalTo(self.messageChatType == MessageChatGroup ? @32 : @16);
         }];
        
        [self.messageContentView mas_makeConstraints:^(MASConstraintMaker *make){
             make.right.equalTo(self.headImageView.mas_left).with.offset(-6);
             make.top.equalTo(self.contentView.mas_top).with.offset(14);
             make.width.lessThanOrEqualTo(@([UIApplication sharedApplication].keyWindow.frame.size.width/5*3)).priorityHigh();
             make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-16).priorityLow();
         }];
        
        [self.messageResendButton mas_makeConstraints:^(MASConstraintMaker *make){
             make.right.equalTo(self.messageContentView.mas_left).with.offset(-6);
             make.centerY.equalTo(self.messageContentView.mas_centerY).with.offset(0);
             make.height.mas_equalTo(@(25));
             make.width.mas_equalTo(@(25));
         }];
        
        [self.messageSendStateImageView mas_makeConstraints:^(MASConstraintMaker *make){
             make.right.equalTo(self.messageContentView.mas_left).with.offset(-8);
             make.centerY.equalTo(self.messageContentView.mas_centerY);
             make.width.equalTo(@50);
             make.height.equalTo(@50);
         }];
        
        [self.messageReadStateImageView mas_makeConstraints:^(MASConstraintMaker *make){
             make.right.equalTo(self.messageContentView.mas_left).with.offset(-8);
             make.centerY.equalTo(self.messageContentView.mas_centerY);
             make.width.equalTo(@10);
             make.height.equalTo(@10);
         }];
    }else if (self.messageOwner == MessageOwnerOther){                                  ///如果是消息接收方
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make){
             make.left.equalTo(self.contentView.mas_left).with.offset(16);
             make.top.equalTo(self.contentView.mas_top).with.offset(16);
             make.width.equalTo(@50);
             make.height.equalTo(@50);
         }];
        
        [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make){
             make.top.equalTo(self.headImageView.mas_top);
             make.left.equalTo(self.headImageView.mas_right).with.offset(16);
             make.width.mas_lessThanOrEqualTo(@120);
             make.height.equalTo(self.messageChatType == MessageChatGroup ? @16 : @0);
         }];
        
        [self.messageContentView mas_makeConstraints:^(MASConstraintMaker *make){
             make.left.equalTo(self.headImageView.mas_right).with.offset(16);
             make.top.equalTo(self.nicknameLabel.mas_bottom).with.offset(4);
             make.width.lessThanOrEqualTo(@([UIApplication sharedApplication].keyWindow.frame.size.width/5*3)).priorityHigh();
             make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-16).priorityLow();
         }];
        
        [self.messageSendStateImageView mas_makeConstraints:^(MASConstraintMaker *make){
             make.left.equalTo(self.messageContentView.mas_right).with.offset(8);
             make.centerY.equalTo(self.messageContentView.mas_centerY);
             make.width.equalTo(@20);
             make.height.equalTo(@20);
         }];
        
        [self.messageReadStateImageView mas_makeConstraints:^(MASConstraintMaker *make){
             make.left.equalTo(self.messageContentView.mas_right).with.offset(8);
             make.centerY.equalTo(self.messageContentView.mas_centerY);
             make.width.equalTo(@10);
             make.height.equalTo(@10);
         }];
        
        [self.messageProgressView mas_makeConstraints:^(MASConstraintMaker *make){
             make.left.equalTo(self.messageContentView.mas_left).with.offset(4);
             make.right.equalTo(self.messageContentView.mas_right).with.offset(-40);
             make.top.equalTo(self.messageContentView.mas_bottom).with.offset(10);
             make.height.mas_equalTo(@(5));
         }];
        
        [self.messageCancelButton mas_makeConstraints:^(MASConstraintMaker *make){
             make.left.equalTo(self.messageProgressView.mas_right).with.offset(4);
             make.top.equalTo(self.messageContentView.mas_bottom).with.offset(1);
             make.height.mas_equalTo(@(20));
             make.width.mas_equalTo(@(20));
         }];
    }
    
    ///泡泡文本
    [self.messageContentBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make){
         make.edges.equalTo(self.messageContentView);
     }];
    
    ///单聊
    if (self.messageChatType == MessageChatSingle){
        [self.nicknameLabel mas_updateConstraints:^(MASConstraintMaker *make){
             make.height.equalTo(@0);
         }];
    }
}


#pragma mark 公有方法
- (void)setup{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nicknameLabel];
    [self.contentView addSubview:self.messageContentView];
    [self.contentView addSubview:self.messageResendButton];
    [self.contentView addSubview:self.messageProgressView];
    [self.contentView addSubview:self.messageCancelButton];
    [self.contentView addSubview:self.messageReadStateImageView];
    [self.contentView addSubview:self.messageSendStateImageView];
    
    self.messageSendStateImageView.hidden = YES;
    self.messageReadStateImageView.hidden = YES;
    self.messageResendButton.hidden       = YES;
    
    if ((MessageTypeImage != [self messageType]) &&
        (MessageTypeVideo != [self messageType]))
    {
        self.messageCancelButton.hidden = YES;
        self.messageProgressView.hidden = YES;
    }
    
    if (self.messageOwner == MessageOwnerSelf){
        [self.messageContentBackgroundImageView setImage:[[UIImage imageNamed:@"chat_to_bg_normal"]
                                                          resizableImageWithCapInsets:UIEdgeInsetsMake(30, 16, 16, 24)
                                                          resizingMode:UIImageResizingModeStretch]];
        
        [self.messageContentBackgroundImageView setHighlightedImage:[[UIImage imageNamed:@"chat_to_bg_normal"]
                                                                     resizableImageWithCapInsets:UIEdgeInsetsMake(30, 16, 16, 24)
                                                                     resizingMode:UIImageResizingModeStretch]];
    }else if (self.messageOwner == MessageOwnerOther){
        [self.messageContentBackgroundImageView setImage:[[UIImage imageNamed:@"chat_from_bg_normal"]
                                                          resizableImageWithCapInsets:UIEdgeInsetsMake(30, 16, 16, 24)
                                                          resizingMode:UIImageResizingModeStretch]];
        
        [self.messageContentBackgroundImageView setHighlightedImage:[[UIImage imageNamed:@"chat_from_bg_normal"]
                                                                     resizableImageWithCapInsets:UIEdgeInsetsMake(30, 16, 16, 24)
                                                                     resizingMode:UIImageResizingModeStretch]];
    }
    
    self.messageContentView.layer.mask.contents = (__bridge id _Nullable)(self.messageContentBackgroundImageView.image.CGImage);
    [self.contentView insertSubview:self.messageContentBackgroundImageView belowSubview:self.messageContentView];
    
    [self updateConstraintsIfNeeded];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.contentView addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.numberOfTouchesRequired = 1;
    longPress.minimumPressDuration = 1.f;
    [self.contentView addGestureRecognizer:longPress];
}

#pragma mark 点击泡泡消息
/**
 * 点击泡泡消息文本事件
 
 @param touches touches description
 @param event event description
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    CGPoint touchPoint = [[touches anyObject] locationInView:self.contentView];
    if (CGRectContainsPoint(self.messageContentView.frame, touchPoint)){
        self.messageContentBackgroundImageView.highlighted = YES;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    self.messageContentBackgroundImageView.highlighted = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    self.messageContentBackgroundImageView.highlighted = NO;
}

#pragma mark 手势事件
/**
 ** 单击手势事件
 */
- (void)handleTap:(UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateEnded){
        CGPoint tapPoint = [tap locationInView:self.contentView];
        if (CGRectContainsPoint(self.messageContentView.frame, tapPoint)){
            [self.delegate messageCellTappedMessage:self];
        }else if (CGRectContainsPoint(self.headImageView.frame, tapPoint)){
            [self.delegate messageCellTappedHead:self];
        }else{
            [self.delegate messageCellTappedBlank:self];
        }
    }
}


/**
 * 点击头像事件
 */
- (void)handleTapHeadImage:(UITapGestureRecognizer *)tap{
    [self.delegate messageCellTappedHeadImage:self];
}


/**
 * 点击重新发送事件
 */
- (void)resendButtonPressed:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellResend:)]){
        [self.delegate messageCellResend:self];
    }
}


/**
 * 点击取消发送事件
 */
- (void)cancelButtonPressed:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellCancel:)])
    {
        [self.delegate messageCellCancel:self];
    }
}


#pragma mark 模型赋值
- (void)configureCellWithData:(id)data{
    
    self.nicknameLabel.text = data[kMessageConfigurationNicknameKey];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:data[kMessageConfigurationAvatarKey]] placeholderImage:[UIImage imageNamed:@"avatar"]];
    
    if (data[kMessageConfigurationReadStateKey]){
        self.messageReadState = [data[kMessageConfigurationReadStateKey] integerValue];
    }
    
    if (data[kMessageConfigurationSendStateKey]){
        self.messageSendState = [data[kMessageConfigurationSendStateKey] integerValue];
    }
    
    if (MessageTypeGifImage == [data[kMessageConfigurationTypeKey] integerValue]){
        self.isGifImage = YES;//如果是Gif图片，不显示背影图片，动图显示不需要带气泡的背景图片
        self.messageContentBackgroundImageView.hidden = YES;
        self.messageCancelButton.hidden = YES;
        self.messageProgressView.hidden = YES;
    }
}


/**
 * 消息发送状态
 */
- (void)setMessageSendState:(MessageSendState)messageSendState{
    _messageSendState = messageSendState;
    if (self.messageOwner == MessageOwnerOther){
        self.messageSendStateImageView.hidden = YES;
    }
    if (MessageSendFail == messageSendState){
        self.messageResendButton.hidden = NO;
    }else if (MessageSendSuccess == messageSendState){
        self.messageResendButton.hidden = YES;
    }
    
    self.messageSendStateImageView.messageSendState = messageSendState;
}


/**
 * 消息读取状态，未读，已读
 */
- (void)setMessageReadState:(MessageReadState)messageReadState{
    _messageReadState = messageReadState;
    if (self.messageOwner == MessageOwnerSelf){
        self.messageSendStateImageView.hidden = YES;
    }
    
    if (MessageUnRead == _messageReadState){
        self.messageReadStateImageView.hidden = NO;
    }else{
        self.messageReadStateImageView.hidden = YES;
    }
}


/**
 * 根据消息类型返回对应的cell
 */
- (MessageType)messageType{
    if ([self isKindOfClass:[ChatTextMessageCell class]])
    {
        return MessageTypeText;
    }
    else if ([self isKindOfClass:[ChatImageMessageCell class]])
    {
        return MessageTypeImage;
    }
    else if ([self isKindOfClass:[ChatVideoMessageCell class]])
    {
        return MessageTypeVideo;
    }
    else if ([self isKindOfClass:[ChatVoiceMessageCell class]])
    {
        return MessageTypeVoice;
    }
    else if ([self isKindOfClass:[ChatLocationMessageCell class]])
    {
        return MessageTypeLocation;
    }
    else if ([self isKindOfClass:[ChatDateTimeMessageCell class]])
    {
        return MessageTypeDateTime;
    }
    else if ([self isKindOfClass:[ChatCallMessageCell class]]){
        if (((ChatCallMessageCell*)self).isVideoCall){
            return MessageTypeVideoCall;
        }else{
            return MessageTypeVoiceCall;
        }
    }
    
    return MessageTypeUnknow;
}

- (MessageChat)messageChatType{
    if ([self.reuseIdentifier containsString:@"GroupCell"]){
        return MessageChatGroup;
    }else if ([self.reuseIdentifier containsString:@"SystemCell"]){
        return MessageChatSystem;
    }
    
    return MessageChatSingle;
}

- (MessageOwner)messageOwner{
    if ([self.reuseIdentifier containsString:@"OwnerSelf"]){
        return MessageOwnerSelf;
    }else if ([self.reuseIdentifier containsString:@"OwnerOther"]){
        return MessageOwnerOther;
    }else if ([self.reuseIdentifier containsString:@"OwnerSystem"]){
        return MessageOwnerSystem;
    }
    return MessageOwnerUnknown;
}


#pragma mark 懒加载控件

/**
 * 用户头像
 */
- (UIImageView *)headImageView{
    if (!_headImageView){
        _headImageView                        = [[UIImageView alloc] init];
        _headImageView.layer.cornerRadius     = 5.0f;
        _headImageView.layer.masksToBounds    = YES;
        _headImageView.backgroundColor        = [UIColor clearColor];
        _headImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapHeadImage:)];
        [_headImageView addGestureRecognizer:tap];
    }
    return _headImageView;
}

/**
 * 用户姓名
 */
-(UILabel *)nicknameLabel{
    if (!_nicknameLabel) {
        _nicknameLabel           = [[UILabel alloc] init];
        _nicknameLabel.font      = [UIFont systemFontOfSize:12.0f];
        _nicknameLabel.textColor = [UIColor blackColor];
    }
    return _nicknameLabel;
}

/**
 * 显示用户消息主体的View
 */
- (ContentView *)messageContentView{
    if (!_messageContentView){
        _messageContentView = [[ContentView alloc] init];
    }
    return _messageContentView;
}

/**
 *  重新发送消息（发送失败或网络失败消息发送不成功）
 */
- (UIButton *)messageResendButton{
    if (!_messageResendButton){
        _messageResendButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_messageResendButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_resend_normal"] forState:UIControlStateNormal];
        [_messageResendButton addTarget:self action:@selector(resendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_messageResendButton sizeToFit];
    }
    return _messageResendButton;
}

/**
 *  消息发送取消
 */
- (UIButton *)messageCancelButton{
    if (!_messageCancelButton){
        _messageCancelButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_messageCancelButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_cancel_normal"] forState:UIControlStateNormal];
        [_messageCancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_messageCancelButton sizeToFit];
    }
    return _messageCancelButton;
}

/**
 *  下载进度view
 */
- (UIView *)messageProgressView{
    if (!_messageProgressView){
        _messageProgressView = [[UIProgressView alloc] init];
        _messageProgressView.progressViewStyle = UIProgressViewStyleDefault;
        _messageProgressView.progressTintColor = [UIColor greenColor];
    }
    return _messageProgressView;
}

/**
 *  消息读取状态视图
 */
- (UIImageView *)messageReadStateImageView{
    if (!_messageReadStateImageView){
        _messageReadStateImageView = [[UIImageView alloc] init];
        _messageReadStateImageView.backgroundColor = [UIColor redColor];
    }
    return _messageReadStateImageView;
}

/**
 * 消息发送状态视图
 */
- (SendImageView *)messageSendStateImageView{
    if (!_messageSendStateImageView){
        _messageSendStateImageView = [[SendImageView alloc] init];
    }
    return _messageSendStateImageView;
}

/**
 * 消息泡泡文本
 */
- (UIImageView *)messageContentBackgroundImageView{
    if (!_messageContentBackgroundImageView){
        _messageContentBackgroundImageView = [[UIImageView alloc] init];
    }
    return _messageContentBackgroundImageView;
}

@end

