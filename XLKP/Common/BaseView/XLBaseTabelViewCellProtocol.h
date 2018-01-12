//
//  XLBaseTabelViewCellProtocol.h
//  XLIM
//
//  Created by Facebook on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WY_BaseModel;
@protocol XLBaseTabelViewCellProtocol <NSObject>

@optional
/**
 *  初始视图
 */
- (void)WY_initConfingViews;
/**
 *  配置数据
 */
- (void)WY_SetupViewModel;
/**
 *  配置信号数据
 */
-(void)WY_ConfigSignalDataSoucre;
/**
 初始化数据
 */
-(void)InitDataViewModel:(WY_BaseModel*)model;

+ (id)CellWithTableView:(UITableView *)tableview;

+(CGFloat)getCellHeight:(WY_BaseModel *)model;

@end
