//
//  ImagePickerUtil.h
//  XLKP
//
//  Created by Facebook on 2018/1/4.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImagePickerDelegate.h"

@interface ImagePickerUtil : NSObject

+ (ImagePickerUtil *)defaultPicker;

- (void)startPickerWithController:(UIViewController<ImagePickerDelegate> *)viewController title:(NSString *)title;

@property (nonatomic,weak) id<ImagePickerDelegate> delegate;
@end
