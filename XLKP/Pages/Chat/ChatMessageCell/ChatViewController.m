//
//  ChatViewController.m
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ChatViewController.h"
#import "UITableView+Register.h"
#import "NSObject+TIMMessageBoby.h"
#import "ChatMessageCell+CellIdentifier.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "ChatAVAudioPlayer.h"

///键盘类
#import "ChatKeyBoard.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "FaceSourceManager.h"

///相机图片类
#import <ZLPhotoActionSheet.h>
#import <ZLPhotoConfiguration.h>
#import <ZLPhotoManager.h>
#import <Photos/Photos.h>
#import "ZLCustomCamera.h"

///自定义相册模型
#import "imagePickModel.h"
#import "ImagePickerUtil.h"

///定位
#import "LocationViewController.h"
#import "MapLocationViewController.h"

///录音
#import "RecordVoiceView.h"

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,TIMMessageListener,ChatMessageCellDelegate,ChatKeyBoardDelegate,ChatKeyBoardDataSource,LocationViewControllerDelegate>
@property(nonatomic,strong)UITableView *chatTableView;
@property(nonatomic,strong)NSMutableArray *messageDateSouce;
@property(nonatomic,strong)TIMConversation *conversation;
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;

///图片
@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;
@property (nonatomic, strong) NSMutableArray *lastSelectProcessedDatas;
@property (nonatomic, assign) BOOL isOriginal;
@property(nonatomic,assign)BOOL isEditor;

///录音
@property(nonatomic,strong)RecordVoiceView *recordView;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = [NSString stringWithFormat:@"与%@聊天",_identifier];
    
    [self TIM_GetLoacalConversationlist];
    [[TIMManager sharedInstance]addMessageListener:self];
    [self.view addSubview:self.chatTableView];
    [self.view addSubview:self.chatKeyBoard];
    [self.view addSubview:self.recordView];
    [self.view updateConstraintsIfNeeded];
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make){
         make.width.mas_equalTo (@(140));
         make.height.mas_equalTo (@(140));
         make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
         make.centerY.equalTo(self.view.mas_centerY).with.offset(0);
     }];
}

/**
 *  获取聊天会话本地消息
 */
-(void)TIM_GetLoacalConversationlist{
    [self.conversation getMessage:20 last:nil succ:^(NSArray *msgs) {
        if (msgs.count>0) {
            for (NSInteger i = msgs.count-1; i>=0; i--) {
                TIMMessage * msg = msgs[i];
                NSMutableDictionary *messageDic = [self PackageTIMMessage:msg ConvIdentifier:[self.conversation getSelfIdentifier]];
                if (messageDic) {
                    messageDic[kMessageConfigurationGroupKey] = @(MessageChatSingle);
                    [self.messageDateSouce addObject:messageDic];
                }
            }
        }
        [self reloadAfterReceiveMessage];
    } fail:^(int code, NSString *msg) {
        NSLog(@"错误消息%@",msg);
    }];
}

/**
 *  获取聊天会话新消息
 */
-(void)onNewMessage:(NSArray *)msgs{
    
    
}

/**
 *  刷新会话列表
 */
- (void)reloadAfterReceiveMessage{
    [self.chatTableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageDateSouce.count - 1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

#pragma mark ----> UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageDateSouce.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *message = self.messageDateSouce[indexPath.row];
    NSString *identifier = [ChatMessageCell cellIdentifierForMessageConfiguration:
                            @{kMessageConfigurationGroupKey:message[kMessageConfigurationGroupKey],
                              kMessageConfigurationOwnerKey:message[kMessageConfigurationOwnerKey],
                              kMessageConfigurationTypeKey:message[kMessageConfigurationTypeKey]}];
    return [tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(ChatMessageCell *cell){
        [cell configureCellWithData:message];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *message = self.messageDateSouce[indexPath.row];
    NSString *strIdentifier = [ChatMessageCell cellIdentifierForMessageConfiguration:
                               @{kMessageConfigurationGroupKey:message[kMessageConfigurationGroupKey],
                                 kMessageConfigurationOwnerKey:message[kMessageConfigurationOwnerKey],
                                 kMessageConfigurationTypeKey:message[kMessageConfigurationTypeKey]}];
    ChatMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:strIdentifier];
    [messageCell configureCellWithData:message];
    messageCell.delegate = self;
    return messageCell;
}


#pragma mark  ===============================   ChatMessageCellDelegate       ========================================================

/**
 *  单点聊天记录的空白处，可以有来关闭键盘
 */
- (void)messageCellTappedBlank:(ChatMessageCell *)messageCell{
    [self.chatKeyBoard keyboardDown];
}

/**
 *  单点聊天记录的HEAD处，暂时未用上
 */
- (void)messageCellTappedHead:(ChatMessageCell *)messageCell{
    
}

/**
 *  单点聊天记录，可以用来浏览图片，播放视频、打开位置信息、播放语音聊天
 */
- (void)messageCellTappedMessage:(ChatMessageCell *)messageCell{
    NSIndexPath *indexPath = [self.chatTableView indexPathForCell:messageCell];
    switch (messageCell.messageType) {
        case MessageTypeImage:
        case MessageTypeGifImage:
        {
            NSLog(@"点击图片");
        }
            break;
        case MessageTypeVoice:
        {
            NSLog(@"点击声音");
            NSURL *url = self.messageDateSouce[indexPath.row][kMessageConfigurationVoiceKey];
            [[ChatAVAudioPlayer sharedInstance] playWithUrl:url finish:^{
                NSLog(@"播放录音");
            }];
        }
            break;
        case MessageTypeVideo:
        {
            NSLog(@"点击视频");
        }
            break;
        case MessageTypeLocation:
        {
            NSLog(@"点击定位");
            CLLocation *location = [[CLLocation alloc] initWithLatitude:31.199196 longitude:121.461520];
            MapLocationViewController *mapView = [[MapLocationViewController alloc]init];
            mapView.location = location;
            [self.navigationController pushViewController:mapView animated:YES];
            [self.chatKeyBoard keyboardDown]; //关闭键盘
        }
            break;
        case MessageTypeVoiceCall:
        case MessageTypeVideoCall:
        {
            NSLog(@"语音,视频呼叫");
        }
            break;
        default:
            break;
    }
}

/**
 *  单点用户头像，用来查看用户详情
 */
- (void)messageCellTappedHeadImage:(ChatMessageCell *)messageCell{
    
}

/**
 *  响应快捷菜单，复制，删除，转发
 */
- (void)messageCell:(ChatMessageCell *)messageCell withActionType:(ChatMessageCellMenuActionType)actionType{
    
}

/**
 *  消息发送失败时，重发消息
 */
- (void)messageCellResend:(ChatMessageCell *)messageCell{
    
}

/**
 *  正在上传或下载文件时，取消操作
 */
- (void)messageCellCancel:(ChatMessageCell *)messageCell{
    
}


#pragma mark  ---> KeyboardViewDelegate
/**
 *  开始录音
 // */
//- (void)startRecordVoice{
//    [_recordView startRecordVoice];
//}

/**
 *  取消录音
 */
//- (void)cancelRecordVoice{
//    [_recordView cancelRecordVoice];
//}
//
///**
// *  录音结束
// */
//- (void)endRecordVoice{
//    [_recordView endRecordVoice];
//}
//
///**
// *  更新录音显示状态,手指向上滑动后提示松开取消录音
// */
//- (void)updateCancelRecordVoice{
//    [_recordView updateCancelRecordVoice];
//}
//
///**
// *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
// */
//- (void)updateContinueRecordVoice{
//    [_recordView updateContinueRecordVoice];
//}


/**
 *  发送普通的文字信息,可能带有表情
 *
 */
//- (void)chatBar:(KeyboardView *)chatBar sendMessage:(NSString *)message{
//    TIMMessage *msg = [self SendMessageWithText:message];
//    [_conversation sendMessage:msg succ:^{
//        NSLog(@"SendMsg Succ");
//        NSMutableDictionary *messageDic = [self PackageTIMMessage:msg ConvIdentifier:[self.conversation getSelfIdentifier]];
//        messageDic[kMessageConfigurationGroupKey] = @(MessageChatSingle);
//        [self addMessage:messageDic];
//    } fail:^(int code, NSString *msg) {
//        NSLog(@"SendMsg Failed:%d->%@", code, msg);
//    }];
//}

/**
 *  发送图片信息,支持多张图片
 *
 *  @param pictures 需要发送的图片信息
 */
//- (void)chatBar:(KeyboardView *)chatBar sendPictures:(NSArray *)pictures imageType:(BOOL)isGif{
//    if (isGif) {
//        if (pictures.count>0) {
//            //            [pictures enumerateObjectsUsingBlock:^(int obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            //                TIMMessage *msg = [self SendMessageWithFaceGifIndex:obj];
//            //                [_conversation sendMessage:msg succ:^{
//            //                    NSLog(@"SendMsg Succ");
//            //                } fail:^(int code, NSString *msg) {
//            //                    NSLog(@"SendMsg Failed:%d->%@", code, msg);
//            //                }];
//            //            }];
//        }
//    }else{
//        if (pictures.count>0) {
//            [pictures enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                TIMMessage *msg = [self SendMessageWithImage:obj isOrignal:YES];
//                [_conversation sendMessage:msg succ:^{
//                    NSLog(@"SendMsg Succ");
//                } fail:^(int code, NSString *msg) {
//                    NSLog(@"SendMsg Failed:%d->%@", code, msg);
//                }];
//            }];
//        }
//    }
//}

/**
 *  发送视频信息,支持多张图片
 *
 *  @param videos 需要发送的视频信息
 */
//- (void)chatBar:(KeyboardView *)chatBar sendVideos:(NSArray *)videos{
//    if (videos.count>0) {
//        [videos enumerateObjectsUsingBlock:^(NSString  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            TIMMessage *msg = [self SendMessageWithVideoPath:obj];
//            [_conversation sendMessage:msg succ:^{
//                NSLog(@"SendMsg Succ");
//            } fail:^(int code, NSString *msg) {
//                NSLog(@"SendMsg Failed:%d->%@", code, msg);
//            }];
//        }];
//    }
//}

/**
 *  发送地理位置信息
 *
 *  @param locationCoordinate 需要发送的地址位置经纬度
 *  @param locationText       需要发送的地址位置对应信息
 */
//- (void)chatBar:(KeyboardView *)chatBar sendLocation:(CLLocationCoordinate2D)locationCoordinate locationText:(NSString *)locationText{
//    TIMMessage *msg = [self SendMessageWithLocationDesc:locationText latitude:locationCoordinate.latitude longitude:locationCoordinate.longitude loactionCover:nil];
//    [_conversation sendMessage:msg succ:^{
//        NSLog(@"SendMsg Succ");
//    } fail:^(int code, NSString *msg) {
//        NSLog(@"SendMsg Failed:%d->%@", code, msg);
//    }];
//}

/**
 *  音视频呼叫
 *
 *  @param calltime 呼叫时长，单位为秒
 *  @param isVideo  NO:音频呼叫; YES:视频呼叫
 */
//- (void)chatBar:(KeyboardView *)chatBar sendCall:(NSString *)calltime withVideo:(BOOL)isVideo{
//
//}

/**
 *  发送语音信息
 *
 *  @param voiceFileName 语音data数据
 *  @param seconds   语音时长
 */
//- (void)chatBar:(KeyboardView *)chatBar sendVoice:(NSString *)voiceFileName seconds:(NSInteger)seconds{
//    NSData *audioData = [NSData dataWithContentsOfFile:voiceFileName];
//    NSInteger dur = (NSInteger)(seconds + 0.5);
//    TIMMessage *msg = [self SendMessageWithSound:audioData duration:dur];
//    [_conversation sendMessage:msg succ:^{
//        NSLog(@"SendMsg Succ");
//    } fail:^(int code, NSString *msg) {
//        NSLog(@"SendMsg Failed:%d->%@", code, msg);
//    }];
//}




/**
 * 添加消息
 
 @param message message description
 */
- (void)addMessage:(NSDictionary *)message{
    [self.messageDateSouce addObject:message];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageDateSouce.count - 1 inSection:0];
    [self.chatTableView reloadData];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}


#pragma mark ---> 初始化视图

-(TIMConversation *)conversation{
    if (!_conversation) {
        _conversation =  [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:_identifier];
    }
    return _conversation;
}

-(NSMutableArray *)messageDateSouce{
    if (!_messageDateSouce) {
        _messageDateSouce = [NSMutableArray arrayWithCapacity:0];
    }
    return _messageDateSouce;
}

-(UITableView *)chatTableView{
    if (!_chatTableView) {
        _chatTableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49) style:UITableViewStylePlain];
        _chatTableView.showsVerticalScrollIndicator =NO;
        _chatTableView.showsHorizontalScrollIndicator =NO;
        _chatTableView.dataSource = self;
        _chatTableView.delegate = self;
        _chatTableView.tableFooterView  =[UIView new];
        _chatTableView.estimatedRowHeight = 0;
        _chatTableView.estimatedSectionFooterHeight = 0;
        _chatTableView.estimatedSectionHeaderHeight = 0;
        _chatTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        [_chatTableView registerChatMessageCellClass];
    }
    return _chatTableView;
}


- (RecordVoiceView *)recordView{
    if (!_recordView){
        _recordView = [[RecordVoiceView alloc] init];
        _recordView.layer.cornerRadius = 10;
        _recordView.clipsToBounds      = YES;
        _recordView.hidden             = YES;
        _recordView.backgroundColor    = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }
    return _recordView;
}

-(NSMutableArray<UIImage *> *)lastSelectPhotos{
    if (!_lastSelectPhotos) {
        
        _lastSelectPhotos = [NSMutableArray arrayWithCapacity:0];
    }
    return _lastSelectPhotos;
}

-(NSMutableArray<PHAsset *> *)lastSelectAssets{
    if (!_lastSelectAssets) {
        _lastSelectAssets = [NSMutableArray arrayWithCapacity:0];
    }
    return _lastSelectAssets;
}

#pragma mark    ==============================            <键盘相关>       ==============================

-(ChatKeyBoard *)chatKeyBoard{
    if (!_chatKeyBoard) {
        _chatKeyBoard =  [ChatKeyBoard keyBoard];
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.dataSource = self;
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleChat;
        //        _chatKeyBoard.placeHolder = @"请输入聊天信息";
        _chatKeyBoard.associateTableView = self.chatTableView;
    }
    return _chatKeyBoard;
}

#pragma mark  ===================================== ChatKeyBoardDataSource ====================================
- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems{
    MoreItem *item1 = [MoreItem moreItemWithPicName:@"Album_Icon" highLightPicName:nil itemName:@"图片"];
    MoreItem *item2 = [MoreItem moreItemWithPicName:@"Chat_Video_Icon" highLightPicName:nil itemName:@"拍摄"];
    MoreItem *item3 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item4 = [MoreItem moreItemWithPicName:@"Chat_Call_Video_Icon" highLightPicName:nil itemName:@"视频聊天"];
    MoreItem *item5 = [MoreItem moreItemWithPicName:@"Chat_Rectangle_Icon" highLightPicName:nil itemName:@"语音聊天"];
    return @[item1, item2, item3,item4,item5];
}

- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemVoice normal:@"voice" high:@"voice_HL" select:@"keyboard"];
    ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemMore normal:@"more_ios" high:@"more_ios_HL" select:nil];
    ChatToolBarItem *item4 = [ChatToolBarItem barItemWithKind:kBarItemSwitchBar normal:@"switchDown" high:nil select:nil];
    return @[item1, item2, item3, item4];
}


#pragma mark  ====================================     录音状态相关         ========================================
- (void)chatKeyBoardDidStartRecording:(ChatKeyBoard *)chatKeyBoard
{
    NSLog(@"开始录音");
     [_recordView startRecordVoice];
}
- (void)chatKeyBoardWillCancelRecoding:(ChatKeyBoard *)chatKeyBoard
{
    NSLog(@"将要取消录音");
}
- (void)chatKeyBoardContineRecording:(ChatKeyBoard *)chatKeyBoard
{
    NSLog(@"继续录音");
}
- (void)chatKeyBoardDidCancelRecording:(ChatKeyBoard *)chatKeyBoard
{
    NSLog(@"已经取消录音");
    [_recordView cancelRecordVoice];
}
- (void)chatKeyBoardDidFinishRecoding:(ChatKeyBoard *)chatKeyBoard
{
    NSLog(@"已经完成录音");
    [_recordView endRecordVoice];
}

- (void)chatKeyBoardUpdateCancelRecording:(ChatKeyBoard *)chatKeyBoard{
    NSLog(@" 更新录音显示状态,手指向上滑动后提示松开取消录音");
    [_recordView updateCancelRecordVoice];
}
- (void)chatKeyBoardUpdateContinueRecording:(ChatKeyBoard *)chatKeyBoard{
    NSLog(@" 更新录音状态,手指重新滑动到范围内,提示向上取消录音");
    [_recordView updateContinueRecordVoice];
}


/**
 * 可自定义网上下载表情图片
 
 @return return value description
 */
- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems{
    NSMutableArray *subjectArray = [NSMutableArray array];
    
    NSArray *sources = @[@"face"];
    
    for (int i = 0; i < sources.count; ++i)
    {
        NSString *plistName = sources[i];
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
        NSDictionary *faceDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSArray *allkeys = faceDic.allKeys;
        
        FaceThemeModel *themeM = [[FaceThemeModel alloc] init];
        themeM.themeStyle = FaceThemeStyleCustomEmoji;
        themeM.themeDecribe = [NSString stringWithFormat:@"f%d", i];
        
        NSMutableArray *modelsArr = [NSMutableArray array];
        
        for (int i = 0; i < allkeys.count; ++i) {
            NSString *name = allkeys[i];
            FaceModel *fm = [[FaceModel alloc] init];
            fm.faceTitle = name;
            fm.faceIcon = [faceDic objectForKey:name];
            [modelsArr addObject:fm];
        }
        themeM.faceModels = modelsArr;
        
        [subjectArray addObject:themeM];
    }
    
    return subjectArray;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.chatKeyBoard keyboardDown];
}


#pragma mark  ==========================================           消息发送         ================================
/**
 * 发送空录音消息
 **
 */
-(void)sendVoiceEmpty{
    TIMMessage *msg = [self SendMessageWithEmptySound];
    [_conversation sendMessage:msg succ:^{
        NSLog(@"SendMsg Succ");
    } fail:^(int code, NSString *msg) {
        NSLog(@"SendMsg Failed:%d->%@", code, msg);
    }];
}


/**
 * 发送文本(包含表情消息)
 
 @param text text description
 */
- (void)chatKeyBoardSendText:(NSString *)text{
    TIMMessage *msg = [self SendMessageWithText:text];
    [_conversation sendMessage:msg succ:^{
        NSLog(@"SendMsg Succ");
        NSMutableDictionary *messageDic = [self PackageTIMMessage:msg ConvIdentifier:[self.conversation getSelfIdentifier]];
        messageDic[kMessageConfigurationGroupKey] = @(MessageChatSingle);
        [self addMessage:messageDic];
    } fail:^(int code, NSString *msg) {
        NSLog(@"SendMsg Failed:%d->%@", code, msg);
    }];
}


/**
 * ChatKeyBoardDataSource 代理回调事件
 
 @param chatKeyBoard chatKeyBoard description  //  [[ImagePickerUtil defaultPicker] startPickerWithController:self title:@"选择图片"];    ///方法1
 @param index index description
 */
- (void)chatKeyBoard:(ChatKeyBoard *)chatKeyBoard didSelectMorePanelItemIndex:(NSInteger)index{
    switch (index) {
        case 0:{   NSLog(@"图片");
            [self.lastSelectProcessedDatas removeAllObjects];
            [self showPhotoLibray];
        }
            break;
        case 1:{    NSLog(@"拍摄");
            ZLCustomCamera *camera = [[ZLCustomCamera alloc] init];
            camera.circleProgressColor =[UIColor greenColor];
            camera.maxRecordDuration = 60;
            camera.allowRecordVideo = YES;
            WS(weakSelf)
            camera.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
                
                if (image) {
                    NSLog(@"发送图片消息");
                }
                
                if (videoUrl) {
                    NSLog(@"发送视频消息");
                }
                
            };
            [self presentViewController:camera animated:YES completion:nil];
        }
            break;
        case 2:{    NSLog(@"定位");
            LocationViewController *locationC = [[LocationViewController alloc] init];
            locationC.delegate = self;
            UINavigationController *locationNav = [[UINavigationController alloc] initWithRootViewController:locationC];
            [self presentViewController:locationNav animated:YES completion:nil];
        }
            break;
        case 3:{    NSLog(@"视频聊天");
            
        }
            break;
        case 4:{    NSLog(@"语音聊天");
            
        }
            break;
        default:
            break;
    }
}


#pragma mark  =================       <LocationViewControllerDelegate> ==================
- (void)cancelLocation{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 发送定位消息
 */
- (void)sendLocation:(CLPlacemark *)placemark{
    [self cancelLocation];
    TIMMessage *msg = [self SendMessageWithLocationDesc:placemark.name latitude:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude loactionCover:nil];
    [_conversation sendMessage:msg succ:^{
        NSLog(@"SendMsg Succ");
    } fail:^(int code, NSString *msg) {
        NSLog(@"SendMsg Failed:%d->%@", code, msg);
    }];
}


#pragma mark   =======       < 相册！相机！>  =======
-(void)showPhotoLibray{
    ZLPhotoActionSheet *photoActionSheetView = [[ZLPhotoActionSheet alloc] init];
    ZLPhotoConfiguration *configuration = [ZLPhotoConfiguration defaultPhotoConfiguration];
    configuration.sortAscending = NO;
    configuration.allowSelectImage = YES;
    configuration.allowSelectGif = NO;
    configuration.allowSelectVideo = NO;
    configuration.allowSelectLivePhoto = NO;
    configuration.allowForceTouch = NO;
    configuration.allowEditImage = NO;
    configuration.allowEditVideo = NO;
    configuration.allowSlideSelect = YES;
    configuration.allowDragSelect = YES;
    configuration.allowMixSelect = NO;
    //设置相册内部显示拍照按钮
    configuration.allowTakePhotoInLibrary = YES;
    //设置在内部拍照按钮上实时显示相机俘获画面
    configuration.showCaptureImageOnTakePhotoBtn = YES;
    //设置照片最大预览数
    configuration.maxPreviewCount = 100;
    //设置照片最大选择数
    configuration.maxSelectCount =  9 - self.lastSelectPhotos.count;
    configuration.maxVideoDuration  = 999999;
    //单选模式是否显示选择按钮
    configuration.showSelectBtn = YES;
    //是否在选择图片后直接进入编辑界面
    configuration.editAfterSelectThumbnailImage = NO;
    //是否在已选择照片上显示遮罩层
    configuration.showSelectedMask = NO;
    configuration.clipRatios = @[GetClipRatio(1, 1)];
    //颜色，状态栏样式
    configuration.selectedMaskColor = UIColorFromRGB(0xFF758C);
    configuration.navBarColor =  [UIColor blackColor];
    configuration.navTitleColor = UIColorFromRGB(0X323232);
    configuration.bottomBtnsNormalTitleColor =  UIColorFromRGB(0xFF758C);
    configuration.bottomBtnsDisableBgColor =  UIColorFromRGB(0xFF758C);
    configuration.bottomViewBgColor =  UIColorFromRGB(0xffffff);
    configuration.statusBarStyle = UIStatusBarStyleDefault;
    //是否允许框架解析图片
    configuration.shouldAnialysisAsset = YES;
    configuration.exportVideoType = ZLExportVideoTypeMp4;
    photoActionSheetView.configuration = configuration;
    photoActionSheetView.sender = self;
    WS(weakSelf)
    [photoActionSheetView setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        NSMutableArray *dataSocure = [NSMutableArray arrayWithCapacity:0];
        WSSTRONG(strongSelf)
        strongSelf.isEditor  = YES;
        strongSelf.isOriginal  =isOriginal;
        [strongSelf.lastSelectAssets addObjectsFromArray:assets.mutableCopy];
        [strongSelf.lastSelectPhotos addObjectsFromArray:images.mutableCopy];
        NSLog(@"image:%@", images);
        
        for (int  i = 0 ; i<strongSelf.lastSelectAssets.count; i++) {
            PHAsset *asset = strongSelf.lastSelectAssets[i];
            imagePickModel *model = [[imagePickModel alloc]init];
            if (asset.mediaType == PHAssetMediaTypeVideo) {     ///视频
                model.pushType = PhotosPushTypeVideo;
                model.durationStr = [ZLPhotoManager getDuration:asset];
                model.duration = [asset duration];
            }else{
                model.pushType = PhotosPushTypeImage;
            }
            model.image = strongSelf.lastSelectPhotos[i];
            [dataSocure addObject:model];
        }
        strongSelf.lastSelectProcessedDatas = [NSMutableArray arrayWithArray:dataSocure];
        [strongSelf sendMessageWithImages];
    }];
    [photoActionSheetView showPhotoLibrary];
}

/**
 *  发送图片消息
 */
-(void)sendMessageWithImages{
    [self.lastSelectProcessedDatas enumerateObjectsUsingBlock:^(imagePickModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TIMMessage *msg = [self SendMessageWithImage:obj.image isOrignal:YES];
        [_conversation sendMessage:msg succ:^{
            NSLog(@"SendMsg Succ");
        } fail:^(int code, NSString *msg) {
            NSLog(@"SendMsg Failed:%d->%@", code, msg);
        }];
    }];
}


@end

