//
//  LocationViewController.h
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationManager.h"

@protocol LocationViewControllerDelegate <NSObject>

- (void)cancelLocation;
- (void)sendLocation:(CLPlacemark *)placemark;

@end


/**
 * 发送地图信息
 */
@interface LocationViewController : UIViewController
@property (weak, nonatomic) id<LocationViewControllerDelegate> delegate;
@end
