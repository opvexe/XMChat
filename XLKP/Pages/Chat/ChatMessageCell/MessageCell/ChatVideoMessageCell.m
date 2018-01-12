//
//  ChatVideoMessageCell.m
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ChatVideoMessageCell.h"

@interface ChatVideoMessageCell ()
@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) UIImageView *boardcastImageView; // 用来显示视频播放的UIImageView
@end

@implementation ChatVideoMessageCell

#pragma mark - 重写基类方法

- (void)updateConstraints{
    [super updateConstraints];
    [self.thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make){
         make.edges.equalTo(self.messageContentView);
         make.height.lessThanOrEqualTo(@200);
     }];
    
    [self.boardcastImageView mas_makeConstraints:^(MASConstraintMaker *make){
         make.centerX.equalTo(self.thumbnailImageView.mas_centerX).with.offset(0);
         make.centerY.equalTo(self.thumbnailImageView.mas_centerY).with.offset(0);
         make.height.mas_equalTo(@40);
         make.width.mas_equalTo(@40);
     }];
}

#pragma mark - 公有方法
- (void)setup{
    [self.messageContentView addSubview:self.thumbnailImageView];
    [self.messageContentView addSubview:self.boardcastImageView];
    [super setup];
}

- (void)configureCellWithData:(id)data{
    [super configureCellWithData:data];
    id image = data[kMessageConfigurationImageKey];
    
    if ([image isKindOfClass:[UIImage class]]){
        self.thumbnailImageView.image = image;
    }else if ([image isKindOfClass:[NSString class]]){
        ////TODO 是一个路径,可能是网址,需要加载
        NSLog(@"是一个路径");
    }else{
        NSLog(@"未知的图片类型");
    }
}


- (void)setUploadProgress:(CGFloat)uploadProgress{
    [self setMessageSendState:MessageSendStateSending];
    [self.messageProgressView setProgress:uploadProgress];
}

- (void)setMessageSendState:(MessageSendState)messageSendState{
    [super setMessageSendState:messageSendState];
    if (messageSendState == MessageSendStateSending){
        if (!self.messageProgressView.superview){
            [self.contentView addSubview:self.messageProgressView];
            [self.contentView addSubview:self.messageCancelButton];
        }
    }else{
        [self.messageProgressView removeFromSuperview];
        [self.messageCancelButton removeFromSuperview];
    }
}

#pragma mark  懒加载
- (UIImageView *)thumbnailImageView{
    if (!_thumbnailImageView){
        _thumbnailImageView = [[UIImageView alloc] init];
        _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _thumbnailImageView;
}

- (UIImageView *)boardcastImageView{
    if (!_boardcastImageView){
        _boardcastImageView = [[UIImageView alloc] init];
        _boardcastImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _boardcastImageView;
}
@end
