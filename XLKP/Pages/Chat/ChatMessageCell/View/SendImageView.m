//
//  SendImageView.m
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "SendImageView.h"

@interface SendImageView ()

@property (nonatomic, weak) UIActivityIndicatorView *indicatorView;

@end
@implementation SendImageView

- (instancetype)init
{
    if ([super init])
    {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicatorView.hidden = YES;
        [self addSubview:self.indicatorView = indicatorView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.indicatorView.frame = self.bounds;
}

#pragma mark - Setters方法

- (void)setMessageSendState:(MessageSendState)messageSendState
{
    _messageSendState = messageSendState;
    if (_messageSendState == MessageSendStateSending)
    {
        [self.indicatorView startAnimating];
        self.indicatorView.hidden = NO;
    }
    else
    {
        [self.indicatorView stopAnimating];
        self.indicatorView.hidden = YES;
    }
    
    switch (_messageSendState)
    {
        case MessageSendStateSending:
        case MessageSendFail:
            self.hidden = NO;
            break;
        default:
            self.hidden = YES;
            break;
    }
}


@end
