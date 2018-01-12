//
//  ImagePickerUtil.m
//  XLKP
//
//  Created by Facebook on 2018/1/4.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "ImagePickerUtil.h"
#import "AlertUtil.h"

@interface ImagePickerUtil ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) UIImagePickerController *imagePicker;

@end
@implementation ImagePickerUtil

+ (ImagePickerUtil *)defaultPicker
{
    static ImagePickerUtil *utils = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        utils = [[self alloc] init];
    });
    return utils;
}

#pragma mark - imagePicker
- (UIImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
}

#pragma mark - action
- (void)startPickerWithController:(UIViewController<ImagePickerDelegate> *)viewController title:(NSString *)title
{
    self.delegate = viewController;
    
    __block UIImagePickerControllerSourceType sourceType ;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[AlertUtil shareInstance] showSheet:title.length > 0 ? title : @"添加图片" message:nil cancelTitle:@"取消" titleArray:@[@"拍照",@"从手机相册选择"] viewController:viewController confirm:^(NSInteger buttonTag) {
            switch (buttonTag) {
                case 0:
                    //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                default:
                    //取消
                    return;
            }
            self.imagePicker.sourceType = sourceType;
            [viewController presentViewController:_imagePicker animated:YES completion:nil];
        }];
    }
    else{
        [[AlertUtil shareInstance] showSheet:@"添加图片" message:nil cancelTitle:@"取消" titleArray:@[@"从手机相册选择"] viewController:viewController confirm:^(NSInteger buttonTag) {
            switch (buttonTag) {
                case 0:
                    //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                default:
                    //取消
                    return;
            }
            self.imagePicker.sourceType = sourceType;
            [viewController presentViewController:_imagePicker animated:YES completion:nil];
        }];
    }
}

#pragma mark - delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self.delegate imagePickerDidFinishedWithInfo:info image:image file:nil type:ImagePickerDelegateImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];
}

@end
