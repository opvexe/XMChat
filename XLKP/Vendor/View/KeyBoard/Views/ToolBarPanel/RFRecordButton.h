//
//  RFRecordButton.h
//  ReordView
//
//  Created by Facebook on 2018/1/12.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RFRecordButton;
@protocol recordButtoDelegate <NSObject>

@optional

/**
 *  开始录音
 */
- (void)startRecordVoiceWithButton:(RFRecordButton *)sender;

/**
 *  取消录音
 */
- (void)cancelRecordVoiceWithButton:(RFRecordButton *)sender;;

/**
 *  录音结束
 */
- (void)endRecordVoiceWithButton:(RFRecordButton *)sender;;

/**
 *  更新录音显示状态,手指向上滑动后提示松开取消录音
 */
- (void)updateCancelRecordVoiceWithButton:(RFRecordButton *)sender;;

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)updateContinueRecordVoiceWithButton:(RFRecordButton *)sender;;

@end


@interface RFRecordButton : UIButton

/*!
 * 代理事件
 */

@property (weak, nonatomic) id<recordButtoDelegate> delegate;

/*!
 * 松开 结束
 */
- (void)setButtonStateWithRecording;

/*!
 * 松开 取消
 */
- (void)setButtonStateWithRecordingCancel;

/*!
 * 按住 说话
 */
- (void)setButtonStateWithNormal;



@end
