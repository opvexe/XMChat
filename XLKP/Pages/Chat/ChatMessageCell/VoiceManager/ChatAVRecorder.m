//
//  ChatAVRecorder.m
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ChatAVRecorder.h"

#define kChatRecordMaxDuration 60             ///最大录音时长

@interface ChatAVRecorder()<AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, copy) NSString          *recordSavePath;
@end
@implementation ChatAVRecorder

- (id)initWithDelegate:(id<ChatMessageVoiceDelegate>)delegate{
    if (self = [super init]) {
        _delegate = delegate;
        self.recordPeak = 1;
        self.recordDuration = 0;
    }
    return self;
}


/**
 * 设置录音参数
 */
-(void)setRecorder{
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@/%@.mp4", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], [NSString uuid]];
    NSURL *url = [NSURL fileURLWithPath:strUrl];
    self.recordSavePath = strUrl;
    NSError *error = nil;
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&error];
    _recorder.meteringEnabled = YES;
    _recorder.delegate = self;
    [_recorder prepareToRecord];
}

- (void)setSesstion{
    self.session = [AVAudioSession sharedInstance];
    NSError *sessionError = nil;
    [self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    _audioSesstionCategory = [self.session category];
    _audioSesstionMode = [self.session mode];
    _audioSesstionCategoryOptions = [self.session categoryOptions];
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride),  &audioRouteOverride);
    if(!self.session){
        NSLog(@"Error creating session: %@", [sessionError description]);
    }else{
        [self.session setActive:YES error:nil];
    }
}
/**
 * 开始录音
 **
 */
- (void)startRecord{
    [self setSesstion];
    [self setRecorder];
    [self startRecording];
}

- (void)startRecording{
    if (self.recordState == EChatRecorder_TooShort) {
        NSLog(@"录音太短");
    }
    
    [_recorder record];
    self.recordState = EChatRecorder_Recoring;      //开始录音
    _recorderTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onRecording) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_recorderTimer forMode:NSRunLoopCommonModes];
    
    _recorderPeakerTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onRecordPeak) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_recorderPeakerTimer forMode:NSRunLoopCommonModes];
}

-(void)onRecording{
    [_recorder updateMeters];
    CGFloat peakPower = 0;
    peakPower = [_recorder peakPowerForChannel:0];
    peakPower = pow(10, (0.05 * peakPower));
    
    NSInteger peak = (NSInteger)((peakPower * 100)/20 + 1);
    if (peak < 1){
        peak = 1;
    }else if (peak > 5){
        peak = 5;
    }
    if (peak != self.recordPeak){
        self.recordPeak = peak;
    }
}


-(void)onRecordPeak{
      _recordDuration++;
    if (_recordDuration == kChatRecordMaxDuration){
        [_recorderTimer invalidate];
        _recorderTimer = nil;
        
        [_recorderPeakerTimer invalidate];
        _recorderPeakerTimer = nil;
        
        self.recordState = EChatRecorder_MaxRecord;
        [self stopRecord];
    } else if (_recordDuration >= 50){
        self.recordDuration = _recordDuration;
        self.recordState = EChatRecorder_Countdown;
        NSLog(@"开始倒计时");
    }else if (_recordDuration == 1){      //空语音消息
        if ([_delegate respondsToSelector:@selector(sendEmptySoundVoice)]) {
            [_delegate sendEmptySoundVoice];
        }
    }
}

/**
 * 停止录制
 */
- (void)stopRecord{
   
    [_recorderTimer invalidate];
    _recorderTimer = nil;
    
    [_recorderPeakerTimer invalidate];
    _recorderPeakerTimer = nil;
    
    NSTimeInterval duration = self.recorder.currentTime;
    
    if (self.recordState == EChatRecorder_RelaseCancel){
        self.recordState = EChatRecorder_Stoped;
        if ([_delegate respondsToSelector:@selector(sendEmptySoundVoice)]) {
            [_delegate sendEmptySoundVoice];
        }
        return;
    }
    
    if (duration<0.5) {
        self.recordState = EChatRecorder_TooShort;
    }else{
        [self.recorder stop];
        NSInteger dur = (NSInteger)(duration + 0.5);
        if ([_delegate respondsToSelector:@selector(endRecordWithFileName:duration:)]){
            [_delegate endRecordWithFileName:self.recordSavePath duration:dur];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.recordState = EChatRecorder_Stoped;
    });
    [self.recorder stop];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.recorder.url.path]){
        if (!self.recorder.recording){
            [self.recorder deleteRecording];
        }
    };
}


- (void)willCancelRecord{
    if (_recordDuration > 50){
        self.recordState = EChatRecorder_Countdown;
    }else{
        self.recordState = EChatRecorder_RelaseCancel;
    }
}

- (void)continueRecord{
    if (_recordDuration > 50){
        self.recordState = EChatRecorder_Countdown;
    }else{
        self.recordState = EChatRecorder_Recoring;
    }
}

/**
 * 取消录制
 */
- (void)cancelRecord{
    [_recorder stop];
    [_recorder deleteRecording];
}

- (NSInteger)recordTime{
    return self.recorder.currentTime + 0.5;
}

- (void)dealloc{
    AVAudioSession *aSession = [AVAudioSession sharedInstance];
    [aSession setCategory:_audioSesstionCategory withOptions:_audioSesstionCategoryOptions error:nil];
    [aSession setMode:_audioSesstionMode error:nil];
    NSLog(@"dealloc = ChatAVRecorder");
}
@end
