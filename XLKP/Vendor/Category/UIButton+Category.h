//
//  UIButton+Category.h
//  XLKP
//
//  Created by Facebook on 2017/11/23.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MKButtonEdgeInsetsStyle) {
    MKButtonEdgeInsetsStyleTop, // image在上，label在下
    MKButtonEdgeInsetsStyleLeft, // image在左，label在右
    MKButtonEdgeInsetsStyleBottom, // image在下，label在上
    MKButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (category)


/**
 导航栏右侧button
 
 @param title 标题
 @return UIButton
 */
+ (UIButton *)rightBarButtonWithTitle:(NSString *)title;

/**
 字体大小、颜色，背景色
 
 @param fontSize 字体大小
 @param textColor 颜色
 @param backgroundColor 背景色
 */
- (void)attributeFontSize:(CGFloat)fontSize
                textColor:(UIColor *)textColor
          backgroundColor:(UIColor *)backgroundColor;


/**
 字体大小、颜色、边框宽度、边框颜色、边框弧度
 
 @param fontSize 字体大小
 @param textColor 颜色
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 @param radius 边框弧度
 */
- (void)attributeFontSize:(CGFloat)fontSize
                textColor:(UIColor *)textColor
              borderWidth:(CGFloat)borderWidth
              borderColor:(UIColor *)borderColor
                   radius:(CGFloat)radius;


/**
 字体大小、颜色、边框弧度，背景色
 
 @param fontSize 文字大小
 @param textColor 颜色
 @param radius 边框弧度
 @param backgroundColor 背景色
 */
- (void)attributeFontSize:(CGFloat)fontSize
                textColor:(UIColor *)textColor
                   radius:(CGFloat)radius
               background:(UIColor *)backgroundColor;


/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end
