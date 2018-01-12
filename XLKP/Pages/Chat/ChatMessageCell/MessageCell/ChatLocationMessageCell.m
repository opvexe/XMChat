//
//  ChatLocationMessageCell.m
//  XLKP
//
//  Created by Facebook on 2017/11/28.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ChatLocationMessageCell.h"

@interface ChatLocationMessageCell ()
@property (nonatomic, strong) UIImageView *locationIV;
@property (nonatomic, strong) UILabel *locationAddressL;
@end
@implementation ChatLocationMessageCell


#pragma mark - 重写基类方法
- (void)updateConstraints{
    [super updateConstraints];
    
    [self.locationIV mas_makeConstraints:^(MASConstraintMaker *make){
         make.left.equalTo(self.messageContentView.mas_left).with.offset(16);
         make.top.equalTo(self.messageContentView.mas_top).with.offset(8);
         make.bottom.equalTo(self.messageContentView.mas_bottom).with.offset(-8);
         make.width.equalTo(@60);
         make.height.equalTo(@60);
     }];
    
    [self.locationAddressL mas_makeConstraints:^(MASConstraintMaker *make){
         make.left.equalTo(self.locationIV.mas_right).with.offset(8);
         make.top.equalTo(self.locationIV.mas_top);
         make.right.equalTo(self.messageContentView.mas_right).with.offset(-16);
         //        make.bottom.equalTo(self.messageContentView.mas_bottom).with.offset(-8);
     }];
}

#pragma mark - 公有方法
- (void)setup{
    [self.messageContentView addSubview:self.locationIV];
    [self.messageContentView addSubview:self.locationAddressL];
    [super setup];
}

- (void)configureCellWithData:(id)data{
    [super configureCellWithData:data];
    _locationAddressL.text= [NSString stringWithFormat:@"%@\n%@", data[kMessageConfigurationTextKey], data[kMessageConfigurationLocationKey]];
}


#pragma mark 懒加载
- (UILabel *)locationAddressL{
    if (!_locationAddressL){
        _locationAddressL = [[UILabel alloc] init];
        _locationAddressL.textColor = [UIColor blackColor];
        _locationAddressL.font = [UIFont systemFontOfSize:16.0f];
        _locationAddressL.numberOfLines = 3;
        _locationAddressL.textAlignment = NSTextAlignmentNatural;
        _locationAddressL.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _locationAddressL;
}

- (UIImageView *)locationIV{
    if (!_locationIV){
        _locationIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
    }
    return _locationIV;
}
@end
