//
//  NSObject+TIMMessageBoby.m
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "NSObject+TIMMessageBoby.h"
#import <AVFoundation/AVFoundation.h>
#import "CachePath.h"

#define kChatPicThumbMaxHeight 190.f  // 聊天图片缩约图最大高度
#define kChatPicThumbMaxWidth 66.f  // 聊天图片缩约图最大宽度

@implementation NSObject (TIMMessageBoby)

-(NSMutableDictionary *)PackageTIMMessage:(TIMMessage *)message ConvIdentifier:(NSString *)identifier{
    
    TIMElem * mesg_elem = [message getElem:0];
    if ([mesg_elem isKindOfClass:[TIMTextElem class]]) {
        return [self TIM_MessageTextElem:message];
    }else if ([mesg_elem isKindOfClass:[TIMImageElem class]]){
        return [self TIM_MessageImageElem:message];
    }else if ([mesg_elem isKindOfClass:[TIMSoundElem class]]){
        return [self TIM_MessageVoiceElem:message];
    }else if ([mesg_elem isKindOfClass:[TIMLocationElem class]]){
        return [self TIM_MessageLocationElem:message];
    }else if ([mesg_elem isKindOfClass:[TIMCustomElem class]]){   ///自定义消息
        
    }else if ([mesg_elem isKindOfClass:[TIMUGCElem class]]){
        
    }else if ([mesg_elem isKindOfClass:[TIMVideoElem class]]){
        //        return [self TIM_MessageVideoElem:message ConvIdentifier:identifier];
    }else if ([mesg_elem isKindOfClass:[TIMFileElem class]]){
        return [self TIM_MessageFileElem:message];
    }
    return  nil;
}


/**
 * 文本消息
 
 @param message message description
 @return return value description
 */
-(NSMutableDictionary *)TIM_MessageTextElem:(TIMMessage *)message{
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
    TIMTextElem *elem = (TIMTextElem *)[message getElem:0];
    messageDict[kMessageConfigurationTextKey] = [elem text];
    messageDict[kMessageConfigurationTypeKey] = @(MessageTypeText);
    if (message.isSelf) {
        messageDict[kMessageConfigurationOwnerKey] = @(MessageOwnerSelf);
    }else{
        messageDict[kMessageConfigurationOwnerKey] = @(MessageOwnerOther);
    }
#warning 用户信息可以在此处加
    return messageDict;
}

/**
 * 图片消息
 
 @param message message description
 @return return value description
 */
-(NSMutableDictionary *)TIM_MessageImageElem:(TIMMessage *)message{
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
    TIMImageElem *elem = (TIMImageElem *)[message getElem:0];
    messageDict[kMessageConfigurationTypeKey] = @(MessageTypeImage);
    if (elem.imageList.count >0) {
        for (TIMImage *timImage in elem.imageList) {
            if (timImage.type == TIM_IMAGE_TYPE_THUMB){
                messageDict[kMessageConfigurationImageKey] = timImage.url;
            }else{
                messageDict[kMessageConfigurationImageKey] = timImage.url;
            }
            break;
        }
    }
    if (message.isSelf) {
        messageDict[kMessageConfigurationOwnerKey] = @(MessageOwnerSelf);
    }else{
        messageDict[kMessageConfigurationOwnerKey] = @(MessageOwnerOther);
    }
    return messageDict;
}



/**
 * 语音消息
 
 @param message message description
 @return return value description
 */
-(NSMutableDictionary *)TIM_MessageVoiceElem:(TIMMessage *)message{
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
    TIMSoundElem *elem = (TIMSoundElem *)[message getElem:0];
    messageDict[kMessageConfigurationTypeKey]        = @(MessageTypeVoice);
    messageDict[kMessageConfigurationVoiceSecondsKey] = @(elem.second);
    if (message.isSelf) {
        messageDict[kMessageConfigurationOwnerKey] = @(MessageOwnerSelf);
    }else{
        messageDict[kMessageConfigurationOwnerKey] = @(MessageOwnerOther);
    }
    NSString *cache = [CachePath getCachePath];
    NSString *loginId = [[TIMManager sharedInstance] getLoginUser];
    NSString *audioDir = [NSString stringWithFormat:@"%@/%@",cache,loginId];
    BOOL isDir = FALSE;
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:audioDir isDirectory:&isDir];
    if (!(isDir && isDirExist)){
        BOOL isCreateDir = [CachePath createDirectoryAtCache:loginId];
        if (!isCreateDir) { return nil; }
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",cache,loginId,elem.uuid];
    if ([CachePath isExistFile:path]){
        NSURL *url = [NSURL fileURLWithPath:path];
        messageDict[kMessageConfigurationVoiceKey]        = url;
    }else{
        [elem getSound:path succ:^{
            NSURL *url = [NSURL fileURLWithPath:path];
            messageDict[kMessageConfigurationVoiceKey]        = url;
        } fail:^(int code, NSString *msg) {
            NSLog(@"播放语音失败:path--->%@",path);
        }];
    }
    return messageDict;
}


/**
 * 视频消息
 
 @param message message description
 @return return value description
 */
-(NSMutableDictionary *)TIM_MessageVideoElem:(TIMMessage *)message ConvIdentifier:(NSString *)identifier;{
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
    ///MARK: 先设置封面
    TIMUGCElem *elem = (TIMUGCElem *)[message getElem:0];
    NSString *hostCachesPath = [self getHostCachesPath:identifier];
    if (!hostCachesPath){ return nil;}
    NSString *imagePath = [NSString stringWithFormat:@"%@/snapshot_%@", hostCachesPath, elem.videoId];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (elem.coverPath && [fileMgr fileExistsAtPath:elem.coverPath]){
        NSLog(@"视频封面路径：%@",elem.coverPath);
        messageDict[kMessageConfigurationVideoCoverKey] = imagePath;
    }else{
        if (elem.videoId && elem.videoId.length > 0){
            [elem.cover getImage:imagePath succ:^{      //kMessageConfigurationVideoCoverKey
                NSLog(@"上传视频封面成功:%@",imagePath);
                messageDict[kMessageConfigurationVideoCoverKey] = imagePath;
            } fail:^(int code, NSString *msg) {
                NSLog(@"上传视频封面失败:%@",msg);
            }];
        }
    }
    
    ///MARK:视频
    TIMUGCElem *Video_elem = (TIMUGCElem *)[message getElem:0];
    if (!(Video_elem.videoId && Video_elem.videoId.length > 0)){
        NSLog(@"小视频ID为空");
        return nil;
    }
    NSString *video_hostCachesPath = [self getHostCachesPath:identifier];
    if (!video_hostCachesPath){
        NSLog(@"获取本地路径出错");
        return nil;
    }
    NSString *videoPath = [NSString stringWithFormat:@"%@/video_%@.%@", hostCachesPath, elem.videoId, elem.video.type];
    NSFileManager *Video_fileMgr = [NSFileManager defaultManager];
    if ([Video_fileMgr fileExistsAtPath:videoPath isDirectory:nil]){
        messageDict[kMessageConfigurationVideoKey] = videoPath;
    } else{
        [elem.video getVideo:videoPath succ:^{
            NSLog(@"视频成功:%@",videoPath);
            messageDict[kMessageConfigurationVideoKey] = videoPath;
        } fail:^(int code, NSString *msg) {
            NSLog(@"视频出错:%@",msg);
        }];
    }
    
    if (message.isSelf) {
        messageDict[kMessageConfigurationOwnerKey] = @(MessageOwnerSelf);
    }else{
        messageDict[kMessageConfigurationOwnerKey] = @(MessageOwnerOther);
    }
    messageDict[kMessageConfigurationTypeKey]         = @(MessageTypeVideo);
    messageDict[kMessageConfigurationVideoUuidKey]     =Video_elem.videoId;
    return messageDict;
}

/**
 * 定位消息
 
 @param message message description
 @return return value description
 */
-(NSMutableDictionary *)TIM_MessageLocationElem:(TIMMessage *)message{
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
    TIMLocationElem *elem = (TIMLocationElem *)[message getElem:0];
    messageDict[kMessageConfigurationTypeKey]     = @(MessageTypeLocation);
    messageDict[kMessageConfigurationTextKey]     = elem.desc;
    messageDict[kMessageConfigurationLocationKey] = [NSString stringWithFormat:@"%.6f,%.6f",elem.latitude,elem.longitude];
    if (message.isSelf) {
        messageDict[kMessageConfigurationOwnerKey] = @(MessageOwnerSelf);
    }else{
        messageDict[kMessageConfigurationOwnerKey] = @(MessageOwnerOther);
    }
    return messageDict;
}


/**
 * 文件消息
 
 @param message message description
 */
-(NSMutableDictionary *)TIM_MessageFileElem:(TIMMessage *)message{
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
    TIMFileElem *elem = (TIMFileElem *)[message getElem:0];
    NSString *fileSize = [self calculSize:elem.fileSize];
    NSString *fileName = [elem.filename lastPathComponent];
    messageDict[kMessageConfigurationTypeKey]        = @(MessageTypeFile);
    messageDict[kMessageConfigurationFileSizeKey]        = fileSize;
    messageDict[kMessageConfigurationFileNameKey]        = fileName;
    if (message.isSelf) {
        messageDict[kMessageConfigurationOwnerKey] = @(MessageOwnerSelf);
    }else{
        messageDict[kMessageConfigurationOwnerKey] = @(MessageOwnerOther);
    }
    if (!(elem.uuid && elem.uuid.length > 0)){
        NSLog(@"文件uuid为空");
        return nil;
    }
    NSString *cachesPaths =[CachePath getCachePath];
    NSString *fileNamePath=[cachesPaths stringByAppendingPathComponent:[elem.filename lastPathComponent]];
    NSLog(@"正在下载文件");
    [elem getFile:fileNamePath succ:^{
        NSLog(@"文件下载成功已保存到%@",cachesPaths);
        messageDict[kMessageConfigurationFileKey]  = cachesPaths;
    } fail:^(int code, NSString *msg) {
        NSLog(@"文件下载失败:%@",msg);
    }];
    return messageDict;
}


/**
 * Gif动画表情
 
 @param message message description
 @return return value description
 */
-(NSMutableDictionary *)TIM_MessageGifFaceElem:(TIMMessage *)message{
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
    
    return messageDict;
}





#pragma mark  私有方法

/**
 * 将封面截图保存到 “Caches/视频id” 路径
 
 @return return value description
 */
- (NSString *)getHostCachesPath:(NSString *)identifier{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,  NSUserDomainMask,YES);
    NSString *cachesPath =[cachesPaths objectAtIndex:0];
    NSString *hostCachesPath = [NSString stringWithFormat:@"%@/%@",cachesPath,identifier];
    if (![fileMgr fileExistsAtPath:hostCachesPath]){
        NSError *err = nil;
        if (![fileMgr createDirectoryAtPath:hostCachesPath withIntermediateDirectories:YES attributes:nil error:&err]){
            NSLog(@"Create HostCachesPath fail: %@", err);
            return nil;
        }
    }
    return hostCachesPath;
}


/**
 * 计算消息文件的大小
 
 @param size size description
 @return return value description
 */
- (NSString *)calculSize:(NSInteger)size{
    int loopCount = 0;
    int mod=0;
    while (size >=1024)
    {
        mod = size%1024;
        size /= 1024;
        loopCount++;
        if (loopCount > 4)
        {
            break;
        }
    }
    
    CGFloat rate=1;
    int loop = loopCount;
    while (loop--)
    {
        rate *= 1000.0;
    }
    CGFloat fSize = size + (CGFloat)mod/rate;
    NSString *sizeUnit;
    switch (loopCount)
    {
        case 0:
            sizeUnit = [[NSString alloc] initWithFormat:@"%.0fB",fSize];
            break;
        case 1:
            sizeUnit = [[NSString alloc] initWithFormat:@"%0.1fKB",fSize];
            break;
        case 2:
            sizeUnit = [[NSString alloc] initWithFormat:@"%0.2fMB",fSize];
            break;
        case 3:
            sizeUnit = [[NSString alloc] initWithFormat:@"%0.3fGB",fSize];
            break;
        case 4:
            sizeUnit = [[NSString alloc] initWithFormat:@"%0.4fTB",fSize];
            break;
        default:
            break;
    }
    return sizeUnit;
}



#pragma mark    ============================ =========================================    发送方


/**
 * 发送文本消息，包含文本，表情，富文本
 */
- (TIMMessage *)SendMessageWithText:(NSString *)text{
    TIMTextElem *elem = [[TIMTextElem alloc] init];
    elem.text = text;
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    return msg;
}


/**
 * 发送图片消息
 */
- (TIMMessage *)SendMessageWithImage:(UIImage *)image isOrignal:(BOOL)origal{
    CGFloat scale = 1;
    scale = MIN(kChatPicThumbMaxHeight/image.size.height, kChatPicThumbMaxWidth/image.size.width);
    
    CGFloat picHeight = image.size.height;
    CGFloat picWidth = image.size.width;
    NSInteger picThumbHeight = (NSInteger) (picHeight * scale + 1);
    NSInteger picThumbWidth = (NSInteger) (picWidth * scale + 1);
    

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *nsTmpDIr = NSTemporaryDirectory();
    NSString *filePath = [NSString stringWithFormat:@"%@uploadFile%3.f", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate]];
    BOOL isDirectory = NO;
    NSError *err = nil;
    
    if ([fileManager fileExistsAtPath:filePath isDirectory:&isDirectory]){
        if (![fileManager removeItemAtPath:nsTmpDIr error:&err]){
            NSLog(@"Upload Image Failed: same upload filename: %@", err);
            return nil;
        }
    }
    if (![fileManager createFileAtPath:filePath contents:UIImageJPEGRepresentation(image, 1) attributes:nil]){
        NSLog(@"Upload Image Failed: fail to create uploadfile: %@", err);
        return nil;
    }
    NSString *thumbPath = [NSString stringWithFormat:@"%@uploadFile%3.f_ThumbImage", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate]];
    UIImage *thumbImage = [image thumbnailWithSize:CGSizeMake(picThumbWidth, picThumbHeight)];
    if (![fileManager createFileAtPath:thumbPath contents:UIImageJPEGRepresentation(thumbImage, 1) attributes:nil]){
        NSLog(@"Upload Image Failed: fail to create uploadfile: %@", err);
        return nil;
    }

    TIMImageElem *elem = [[TIMImageElem alloc] init];
    elem.path = filePath;
    
    if (origal){
        elem.level = TIM_IMAGE_COMPRESS_ORIGIN;
    }else{
        elem.level = TIM_IMAGE_COMPRESS_HIGH;
    }
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    
    return msg;
}

/**
 * 发送文件
 */
- (TIMMessage *)SendMessageWithFilePath:(NSURL *)filePath{
    
    if (!filePath){
        return nil;
    }
    TIMFileElem *elem = [[TIMFileElem alloc] init];
    elem.path = [filePath absoluteString];
    elem.fileSize = (int)elem.fileSize;
    elem.filename = [filePath absoluteString];
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    return msg;
}


/**
 * 撤回消息
 */
- (TIMMessage *)SendMessageWithRevoked:(NSString *)sender{
    
    TIMCustomElem *elem = [[TIMCustomElem alloc] init];
    NSDictionary *dataDic = @{@"sender":sender, @"REVOKED":@1};
    NSError *error = nil;
    elem.data = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:&error];
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    return msg;
}

/**
 * 发送声音消息
 */
-(TIMMessage *)SendMessageWithSound:(NSData *)data duration:(NSInteger)dur{
    
    if (!data){
        return nil;
    }
    NSString *cache = [CachePath getCachePath];
    NSString *loginId = [[TIMManager sharedInstance] getLoginUser];
    
    NSDate *date = [[NSDate alloc] init];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%llu",(unsigned long long)time];
    NSString *soundSaveDir = [NSString stringWithFormat:@"%@/%@/Audio",cache,loginId];
    
    if (![CachePath isExistFile:soundSaveDir]){
        BOOL isCreateDir = [[NSFileManager defaultManager] createDirectoryAtPath:soundSaveDir withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreateDir){
            return nil;
        }
    }
    
    NSString *soundSavePath = [NSString stringWithFormat:@"%@/%@",soundSaveDir,timeStr];
    if (![CachePath isExistFile:soundSavePath]){
        BOOL isCreate = [[NSFileManager defaultManager] createFileAtPath:soundSavePath contents:nil attributes:nil];
        if (!isCreate){
            return nil;
        }
    }
    BOOL isWrite = [data writeToFile:soundSavePath atomically:YES];
    if (!isWrite){
        return nil;
    }
    
    TIMSoundElem *elem = [[TIMSoundElem alloc] init];
    elem.path = soundSavePath;
    elem.second = (int)dur;
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    return msg;
}

/**
 * 发送空的声音消息

 */
-(TIMMessage *)SendMessageWithEmptySound{
    
    TIMSoundElem *elem = [[TIMSoundElem alloc] init];
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    return msg;
}


/**
 * 发送视频消息
 */
- (TIMMessage *)SendMessageWithVideoPath:(NSString *)videoPath{
    
    if (!videoPath){
        return nil;
    }
    //视频截图
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    CMTime time = CMTimeMakeWithSeconds(1.0, 30);   // 1.0为截取视频1.0秒处的图片，30为每秒30帧
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:nil error:nil];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    UIGraphicsBeginImageContext(CGSizeMake(240, 320));
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0,0, 240, 320)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    NSData *snapshotData = UIImageJPEGRepresentation(scaledImage, 0.75);
    
    //保存截图到临时目录
    NSString *tempDir = NSTemporaryDirectory();
    NSString *snapshotPath = [NSString stringWithFormat:@"%@%3.f", tempDir, [NSDate timeIntervalSinceReferenceDate]];
    
    NSError *err;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if (![fileMgr createFileAtPath:snapshotPath contents:snapshotData attributes:nil]){
        NSLog(@"Upload Image Failed: fail to create uploadfile: %@", err);
        return nil;
    }
    
    TIMUGCVideo* video = [[TIMUGCVideo alloc] init];
    video.type = @"mp4";
    video.duration = (int)urlAsset.duration.value/urlAsset.duration.timescale;
    
    TIMUGCCover *corver = [[TIMUGCCover alloc] init];
    corver.type = @"jpg";
    corver.width = scaledImage.size.width;
    corver.height = scaledImage.size.height;
    
    TIMUGCElem* elem = [[TIMUGCElem alloc] init];
    elem.video = video;
    elem.videoPath = videoPath;
    elem.coverPath = snapshotPath;
    elem.cover = corver;
    
    TIMMessage* msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    
    return msg;
}

/**
 * 定位消息
 */
-(TIMMessage *)SendMessageWithLocationDesc:(NSString *)desc latitude:(double)latitude longitude:(double)longitude loactionCover:(NSString *)coverPic{
    
    TIMLocationElem * location_elem = [[TIMLocationElem alloc] init];
    [location_elem setDesc:desc];
    [location_elem setLatitude:latitude];
    [location_elem setLongitude:longitude];
    
    TIMMessage * msg = [[TIMMessage alloc] init];
    [msg addElem:location_elem];
    return msg;
}

/**
 * 发送Gif动图表情
 */
-(TIMMessage *)SendMessageWithFaceGifIndex:(int)index{
    
    TIMFaceElem * face_elem = [[TIMFaceElem alloc] init];
//    [image_elem setIndex:index];
    TIMMessage * msg = [[TIMMessage alloc] init];
    [msg addElem:face_elem];
    return msg;
}
@end

