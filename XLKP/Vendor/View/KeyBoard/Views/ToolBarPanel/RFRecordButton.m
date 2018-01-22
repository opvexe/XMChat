//
//  RFRecordButton.m
//  ReordView
//
//  Created by Facebook on 2018/1/12.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "RFRecordButton.h"

#define kGetColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@implementation RFRecordButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = kGetColor(247, 247, 247);
        
        [self setTitle:@"按住 说话" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        self.layer.cornerRadius = 5.0f;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1.0].CGColor;

        UILongPressGestureRecognizer *presss = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressForRecord:)];
        [self addGestureRecognizer:presss];
    }
    return self;
}

/*!
 * 松开 开始
 */
- (void)setButtonStateWithRecordingCancel{
    self.backgroundColor = kGetColor(214, 215, 220); //214,215,220
    [self setTitle:@"松开 开始" forState:UIControlStateNormal];
}
/*!
 * 松开 结束
 */
- (void)setButtonStateWithRecording
{
    self.backgroundColor = kGetColor(214, 215, 220); //214,215,220
    [self setTitle:@"松开 结束" forState:UIControlStateNormal];
}

/*!
 * 按住 说话
 */
- (void)setButtonStateWithNormal
{
    self.backgroundColor = kGetColor(247, 247, 247);
    [self setTitle:@"按住 说话" forState:UIControlStateNormal];
}


/*!
 *  长按手势
 */
- (void)longPressForRecord:(UILongPressGestureRecognizer *)press{
    static BOOL bSend;
    switch (press.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [self startRecordVoice];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint currentPoint = [press locationInView:press.view];
            
            if (currentPoint.y < -50)
            {
                [self updateCancelRecordVoice];
                bSend = NO;
            }
            else
            {
                bSend = YES;
                [self updateContinueRecordVoice];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (bSend)
            {
                [self endRecordVoice];
            }
            else
            {
                [self cancelRecordVoice];
            }
            break;
        }
        case UIGestureRecognizerStateFailed:
            NSLog(@"failed");
            break;
        default:
            break;
    }
}


/**
 *  开始录音
 */
- (void)startRecordVoice{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startRecordVoiceWithButton:)]){
        [self.delegate startRecordVoiceWithButton:self];
    }
}

/**
 *  取消录音
 */
- (void)cancelRecordVoice{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelRecordVoiceWithButton:)]){
        [self.delegate cancelRecordVoiceWithButton:self];
    }
}

/**
 *  录音结束
 */
- (void)endRecordVoice{
    if (self.delegate && [self.delegate respondsToSelector:@selector(endRecordVoiceWithButton:)]){
        [self.delegate endRecordVoiceWithButton:self];
    }
}

/**
 *  更新录音显示状态,手指向上滑动后提示松开取消录音
 */
- (void)updateCancelRecordVoice{
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateCancelRecordVoiceWithButton:)]){
        [self.delegate updateCancelRecordVoiceWithButton:self];
    }
}

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)updateContinueRecordVoice{
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateContinueRecordVoiceWithButton:)]){
        [self.delegate updateContinueRecordVoiceWithButton:self];
    }
}



@end
