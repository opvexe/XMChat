//
//  ChatTextMessageCell.m
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ChatTextMessageCell.h"
#import "FaceManager.h"

@interface ChatTextMessageCell()
@property(nonatomic,strong)UILabel *messageTextL;
@property(nonatomic,strong)NSDictionary *textStyle;
@end
@implementation ChatTextMessageCell


#pragma mark - 重写基类方法

- (void)updateConstraints{
    [super updateConstraints];
    [self.messageTextL mas_makeConstraints:^(MASConstraintMaker *make){
         make.edges.equalTo(self.messageContentView).with.insets(UIEdgeInsetsMake(8, 16, 8, 16));
     }];
}

#pragma mark - 公有方法
- (void)setup{
    [self.messageContentView addSubview:self.messageTextL];
    [super setup];
}


- (void)configureCellWithData:(id)data{
    [super configureCellWithData:data];
    NSMutableAttributedString *attrS = [FaceManager emotionStrWithString:data[kMessageConfigurationTextKey]];
    [attrS addAttributes:self.textStyle range:NSMakeRange(0, attrS.length)];
    self.messageTextL.attributedText = attrS;
}

- (UILabel *)messageTextL{
    if (!_messageTextL){
        _messageTextL = [[UILabel alloc] init];
        _messageTextL.textColor = [UIColor blackColor];
        _messageTextL.font = [UIFont systemFontOfSize:16.0f];
        _messageTextL.numberOfLines = 0;
        _messageTextL.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _messageTextL;
}

- (NSDictionary *)textStyle{
    if (!_textStyle){
        UIFont *font = [UIFont systemFontOfSize:14.0f];
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = self.messageOwner == MessageOwnerSelf ? NSTextAlignmentRight : NSTextAlignmentLeft;
        style.alignment = NSTextAlignmentLeft;
        style.paragraphSpacing = 0.25 * font.lineHeight;
        style.hyphenationFactor = 1.0;
        _textStyle = @{NSFontAttributeName: font,NSParagraphStyleAttributeName: style};
    }
    return _textStyle;
}

@end
