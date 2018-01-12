//
//  UIImage+TintColor.h
//  XLKP
//
//  Created by Facebook on 2017/11/24.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 * 颜色转图片
 **
 */
@interface UIImage (TintColor)
/**
 *

 @param tintColor tintColor description
 @return return value description
 */
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

/**
 *

 @param tintColor tintColor description
 @param blendMode blendMode description
 @return return value description
 */
- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;


/**
 *

 @param tintColor tintColor description
 @return return value description
 */
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;


/**
 * 颜色转图片

 @param color color description
 @return return value description
 */
+(UIImage*)createImageWithColor:(UIColor*) color;


/**
 * 图片缩放

 @param asize asize description
 @return return value description
 */
- (UIImage *)thumbnailWithSize:(CGSize)asize;
@end
