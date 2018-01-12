//
//  NSObject+TIMMessageBoby.h
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  包装消息体
 **
 */

@interface NSObject (TIMMessageBoby)

#pragma mark   -----> 包装消息体(接收方)
/**
 * 包装消息体(接收方)

 @param message message description
 @param identifier identifier description
 @return return value description
 */
-(NSMutableDictionary *)PackageTIMMessage:(TIMMessage *)message ConvIdentifier:(NSString *)identifier;


#pragma mark   --------> 包装消息体(发送方)

/**
 * 发送文本消息，包含文本，表情，富文本
 
 @param text text description
 @return return value description
 */
- (TIMMessage *)SendMessageWithText:(NSString *)text;


/**
 * 发送静态图片
 
 @param image image description
 @param origal origal description
 @return return value description
 */
- (TIMMessage *)SendMessageWithImage:(UIImage *)image isOrignal:(BOOL)origal;


/**
 * 发送文件

 @param filePath filePath description
 @return return value description
 */
- (TIMMessage *)SendMessageWithFilePath:(NSURL *)filePath;


/**
 * 撤回消息

 @param sender sender description
 @return return value description
 */
- (TIMMessage *)SendMessageWithRevoked:(NSString *)sender;


/**
 * 发送声音消息

 @param data data description
 @param dur dur description
 @return return value description
 */
-(TIMMessage *)SendMessageWithSound:(NSData *)data duration:(NSInteger)dur;


/**
 * 发送空的声音消息

 @return return value description
 */
-(TIMMessage *)SendMessageWithEmptySound;



/**
 * 发送视频消息

 @param videoPath videoPath description
 @return return value description
 */
- (TIMMessage *)SendMessageWithVideoPath:(NSString *)videoPath;



/**
 * 发送定位消息,包含定位图片截图coverPic

 @param desc desc description
 @param latitude latitude description
 @param longitude longitude description
 @param coverPic coverPic description
 @return return value description
 */
-(TIMMessage *)SendMessageWithLocationDesc:(NSString *)desc latitude:(double)latitude longitude:(double)longitude loactionCover:(NSString *)coverPic;


/**
 * 发送Gif动图表情

 @return return value description
 */
-(TIMMessage *)SendMessageWithFaceGifIndex:(int)index;

@end
