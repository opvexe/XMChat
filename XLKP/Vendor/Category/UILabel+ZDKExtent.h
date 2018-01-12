//
//  UILabel+ZDKExtent.h
//  jingchangzhidekan
//
//  Created by shumin.tao on 16/6/21.
//  Copyright © 2016年 maco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ZDKExtent)


/**
 * 未知区域 获取尺寸

 @param size size description
 @return return value description
 */
- (CGSize)textSizeIn:(CGSize)size;

/**
 * 创建 UILabel

 @param color color description
 @param font fontSize description
 @return return value description
 */
+ (instancetype)labelWithColor:(UIColor *)color font:(UIFont *)font;


/**
 * 创建 UILabel

 @param color color description
 @param font font description
 @param alignment alignment description
 @return return value description
 */
+ (instancetype)labelWithColor:(UIColor *)color font:(UIFont *)font  alignment:(NSTextAlignment)alignment;
/**
 * 创建 UILabel
 *
 *  @param title    标题
 *  @param color    标题颜色
 *  @param fontSize 字体大小
 *
 *  @return UILabel(文本水平居中)
 */
+ (instancetype)labelWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize;


/**
 * 创建 UILabel
 *
 *  @param title    标题
 *  @param color    标题颜色
 *  @param font     字体
 *
 *  @return UILabel(文本水平居中)
 */
+ (instancetype)labelWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font;


/**
 *  创建 UILabel
 *
 *  @param title     标题
 *  @param color     标题颜色
 *  @param fontSize  字体大小
 *  @param alignment 对齐方式
 *
 *  @return UILabel
 */
+ (instancetype)labelWithTitle:(NSString *)title color:(UIColor *)color fontSize:(CGFloat)fontSize alignment:(NSTextAlignment)alignment;


/**
 *  创建 UILabel
 *
 *  @param title     标题
 *  @param color     标题颜色
 *  @param font      字体
 *  @param alignment 对齐方式
 *
 *  @return UILabel
 */
+ (instancetype)labelWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font alignment:(NSTextAlignment)alignment;

/**
 *  创建 单行UILabel
 *
 *  @param title     标题
 *  @param color     标题颜色
 *  @param font      字体
 *  @param alignment 对齐方式
 *
 *  @return UILabel
 */
+ (instancetype)SinglelabelWithTitle:(NSString *)title color:(UIColor *)color font:(UIFont *)font alignment:(NSTextAlignment)alignment;
@end
