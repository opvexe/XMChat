//
//  MapLocationViewController.h
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


/**
 * 点击地图
 */
@interface MapLocationViewController : UIViewController

@property(nonatomic,strong) CLLocation *location;
@end




#pragma mark   --- MyAnnoation

@interface MyAnnoation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
