//
//  imagePickModel.h
//  XLKP
//
//  Created by Facebook on 2018/1/5.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *   图片类型
 */
typedef NS_ENUM(NSUInteger, PhotosPushType) {
    /**
     *  无图片
     */
    PhotosPushTypeNone,
    /**
     *  相册视频
     */
    PhotosPushTypeVideo,
    /**
     *  相册图片
     */
    PhotosPushTypeImage,
};
@interface imagePickModel : NSObject
/**
 *  选择相册类型
 */
@property(nonatomic,assign)PhotosPushType pushType;
/**
 *  相册图片
 */
@property(nonatomic,strong)UIImage *image;
/**
 *  相册图片url
 */
@property(nonatomic,strong)NSString *fileUrl;
/**
 *  相册视频持续时间
 */
@property(nonatomic,assign)CGFloat duration;
/**
 *  相册视频
 */
@property(nonatomic,copy)NSString *durationStr;
/**
 *  选择回调
 */
@property (nonatomic, copy) void (^didSelectionHandler)(imagePickModel *model);
/**
 *  录制声音
 */
@property(nonatomic,assign)BOOL isRecordVoice;
@end
