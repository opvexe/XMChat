//
//  NSString+FixedHeight.m
//  XLKP
//
//  Created by Facebook on 2017/11/24.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "NSString+FixedHeight.h"

@implementation NSString (FixedHeight)


/**
 *  根据一定宽度和字体计算高度
 *
 *  @param maxWidth 最大宽度
 *  @param font  字体
 *
 *  @return 返回计算好高度的size
 */
- (CGSize)stringHeightWithMaxWidth:(CGFloat)maxWidth andFont:(UIFont*)font
{
    return  [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                               options:NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{NSFontAttributeName:font}
                               context:nil].size;
}



/**
 *  根据一定高度和字体计算宽度
 *
 *  @param maxHeight 最大高度
 *  @param font      字体
 *
 *  @return 返回计算宽度的size
 */
- (CGSize)stringWidthWithMaxHeight:(CGFloat)maxHeight andFont:(UIFont*)font
{
    return  [self boundingRectWithSize:CGSizeMake(MAXFLOAT, maxHeight)
                               options:NSStringDrawingUsesLineFragmentOrigin
                            attributes:@{NSFontAttributeName:font}
                               context:nil].size;
}
@end
