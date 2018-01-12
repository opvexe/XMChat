//
//  ChatViewController.h
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController
@property (nonatomic,copy) NSString *identifier;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,assign) MessageChat messageChatType;
@end
