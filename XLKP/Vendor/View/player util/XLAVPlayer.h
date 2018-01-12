//
//  XLAVPlayer.h
//  XLKP
//
//  Created by Facebook on 2018/1/5.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * 视频播放器
 */
@interface XLAVPlayer : UIView
/**
 * 构造播放器
 
 @param frame frame description
 @param bgView bgView description
 @param url url description
 @return return value description
 */
- (instancetype)initWithFrame:(CGRect)frame withShowInView:(UIView *)bgView url:(NSURL *)url;
/**
 * 视频播放地址
 */
@property (copy, nonatomic) NSURL *videoUrl;

/**
 * 停止播放
 */
- (void)stopPlayer;
@end
