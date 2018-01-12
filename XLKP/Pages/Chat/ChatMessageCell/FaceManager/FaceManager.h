//
//  FaceManager.h
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#define kFaceIDKey          @"face_id"
#define kFaceNameKey        @"face_name"
#define kFaceImageNameKey   @"face_image_name"

#define kFaceRankKey        @"face_rank"
#define kFaceClickKey       @"face_click"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 *  表情管理类,可以获取所有的表情名称
 *  TODO 直接获取所有的表情Dict,添加排序功能,对表情进行排序,常用表情排在前面
 */
@interface FaceManager : NSObject

+ (instancetype)shareInstance;


#pragma mark - emoji表情相关

/**
 *  获取所有的表情图片名称
 *
 *  @return 所有的表情图片名称
 */
+ (NSArray *)emojiFaces;

/**
 *  获取所有的gif图片名称
 *
 *  @return gif表情图片名称
 */
+ (NSArray *)gifFaces;

+ (NSString *)faceImageNameWithFaceID:(NSUInteger)faceID;

+ (NSString *)faceNameWithFaceID:(NSUInteger)faceID;
/**
 *  将文字中带表情的字符处理换成图片显示
 *
 *  @param strText 未处理的文字
 *
 *  @return 处理后的文字
 */
+ (NSMutableAttributedString *)emotionStrWithString:(NSString *)strText;


#pragma mark - 最近表情相关处理


/**
 获取最近使用的表情图片

 @return return value description
 */
+ (NSArray *)recentFaces;


/**
 *  存储一个最近使用的face
 *
 *  @param dict 包含以下key-value键值对
 *  face_id     表情id
 *  face_name   表情名称
 *  @return 是否存储成功
 */
+ (BOOL)saveRecentFace:(NSDictionary *)dict;


@end
