//
//  ChatAVAudioPlayer.m
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ChatAVAudioPlayer.h"

@interface ChatAVAudioPlayer()<AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *soundPlayer;
@property (nonatomic, copy) CommonVoidBlock playCompletion;
@end
@implementation ChatAVAudioPlayer

static ChatAVAudioPlayer *_sharedPlayer = nil;

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPlayer = [[ChatAVAudioPlayer alloc ] init];
    });
    return _sharedPlayer;
}

+ (void)destory{
    [_sharedPlayer stopPlay];
    _sharedPlayer.soundPlayer = nil;
    _sharedPlayer.playCompletion = nil;
}


- (void)playWith:(NSData *)data finish:(CommonVoidBlock)completion{
    [self stopPlay];
    self.playCompletion = completion;
    NSError *playerError = nil;
    _soundPlayer = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
    if (_soundPlayer){
        _soundPlayer.delegate = self;
        [_soundPlayer prepareToPlay];
        [_soundPlayer play];
    }else{
        NSLog(@"Error creating player: %@", [playerError description]);
        if (_playCompletion){
            _playCompletion();
        }
    }
}

- (void)playWithUrl:(NSURL *)url finish:(CommonVoidBlock)completion{
    [self stopPlay];
    self.playCompletion = completion;
    NSError *playerError = nil;
    NSError *err = nil;
    _soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    if (_soundPlayer){
        _soundPlayer.delegate = self;
        [_soundPlayer prepareToPlay];
        [_soundPlayer play];
    }else{
        NSLog(@"Error creating player: %@", [playerError description]);
        if (_playCompletion){
            _playCompletion();
        }
    }
}

- (void)stopPlay{
    if (_playCompletion){
        _playCompletion();
    }
    
    if (_soundPlayer){
        if (_soundPlayer.isPlaying){
            [_soundPlayer stop];
        }
        _soundPlayer.delegate = nil;
        _soundPlayer = nil;
    }
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (_playCompletion){
        _playCompletion();
    }
    _playCompletion = nil;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    if (_playCompletion){
        _playCompletion();
    }
    _playCompletion = nil;
}


@end
