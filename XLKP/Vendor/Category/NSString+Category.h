//
//  NSString+Category.h
//  XLKP
//
//  Created by Facebook on 2017/11/27.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)


/**
 * 获取UUID

 @return return value description
 */
+ (NSString *)uuid;


/**
 * 获取沙河文件路径

 @return return value description
 */
+ (NSString *)documentPath;

/**
 * URL

 @return return value description
 */
- (NSString*)stringByURLEncodingStringParameter;


#pragma mark  ----- Common


/**
 * 是否为空

 @param string string description
 @return return value description
 */
+ (BOOL)isEmpty:(NSString *)string;


/**
 * MD5加密

 @return return value description
 */
- (NSString *)MD5String;
@end
