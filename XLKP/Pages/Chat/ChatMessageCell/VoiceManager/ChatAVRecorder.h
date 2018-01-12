//
//  ChatAVRecorder.h
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//


/**
 * 录音编码类
 **
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


typedef NS_ENUM(NSInteger, ChatRecorderState){
    EChatRecorder_Stoped,
    EChatRecorder_Recoring,
    EChatRecorder_RelaseCancel,
    EChatRecorder_Countdown,
    EChatRecorder_MaxRecord,
    EChatRecorder_TooShort,
};

@protocol ChatMessageVoiceDelegate <NSObject>

/**
 * 结束录音

 @param fileName fileName description
 @param seconds seconds description
 */
- (void)endRecordWithFileName:(NSString *)fileName duration:(NSInteger)seconds;


/**
 * 发送空的语音消息
 */
-(void)sendEmptySoundVoice;

/**
 * 录音失败
 */
- (void)failRecord;

@end

@interface ChatAVRecorder : NSObject
{
    NSString                        *_audioSesstionCategory;    // 进入房间时的音频类别
    NSString                        *_audioSesstionMode;        // 进入房间时的音频模式
    AVAudioSessionCategoryOptions   _audioSesstionCategoryOptions;  // 进入房间时的音频类别选项
}
@property (nonatomic, weak) id<ChatMessageVoiceDelegate> delegate;
@property (nonatomic, assign) ChatRecorderState recordState;
@property (nonatomic, assign) CGFloat           recordPeak;
@property (nonatomic, assign) NSInteger         recordDuration;
@property (nonatomic, strong) NSTimer           *recorderTimer;
@property (nonatomic, strong) NSTimer           *recorderPeakerTimer;
/**
 * 初始化

 @param delegate delegate description
 @return return value description
 */
- (id)initWithDelegate:(id<ChatMessageVoiceDelegate>)delegate;

/**
 * 开始录制
 */
- (void)startRecord;


/**
 * 取消录制
 */
- (void)willCancelRecord;


/**
 * 继续录制
 */
- (void)continueRecord;
/**
 * 停止录制
 */
- (void)stopRecord;

/**
 * 取消录制
 */
- (void)cancelRecord;

@end
