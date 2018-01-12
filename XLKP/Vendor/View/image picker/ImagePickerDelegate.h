//
//  ImagePickerDelegate.h
//  XLKP
//
//  Created by Facebook on 2018/1/4.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ImagePickerDelegateType) {
    ImagePickerDelegateImage = 0,
    ImagePickerDelegateVideo = 1,
};

@protocol ImagePickerDelegate <NSObject>
- (void)imagePickerDidFinishedWithInfo:(NSDictionary *)info image:(UIImage *) thumIamge file:(NSURL *) url type:(ImagePickerDelegateType) type;
@end
