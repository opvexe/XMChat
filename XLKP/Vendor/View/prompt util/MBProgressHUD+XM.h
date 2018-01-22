//
//  MBProgressHUD+XM.h
//  XLKP
//
//  Created by Facebook on 2018/1/22.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (XM)
/*!
 * 成功提示图
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
/*!
 * 失败提示图
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;
/*!
 * 展示自定义提示文字
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
/*!
 * 成功提示图
 */
+ (void)showSuccess:(NSString *)success;
/*!
 * 失败提示图
 */
+ (void)showError:(NSString *)error;
/*!
 * 展示自定义提示文字
 */
+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)showProcessHud:(NSString *)msg toView:(UIView *)view;
/*!
 * 隐藏提示图
 */
+ (void)hideHUDForView:(UIView *)view;
/*!
 * 隐藏提示图
 */
+ (void)hideHUD;
@end
