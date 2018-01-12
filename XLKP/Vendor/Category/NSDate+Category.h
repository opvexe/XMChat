//
//  NSDate+Category.h
//  XLIM
//
//  Created by Facebook on 2017/11/20.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Category)


- (BOOL)isToday;

- (BOOL)isYesterday;

- (NSString *)shortTimeTextOfDate;

- (NSString *)timeTextOfDate;

@end
