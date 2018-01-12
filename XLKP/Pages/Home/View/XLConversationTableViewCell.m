//
//  XLConversationTableViewCell.m
//  XLIM
//
//  Created by Facebook on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "XLConversationTableViewCell.h"
#import "XLConversationModel.h"

@interface XLConversationTableViewCell()
@property (nonatomic,strong) UIImageView *userHeadImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *updateLabel;
@property (nonatomic,strong) UILabel *messageLabel;
@property (nonatomic,strong) UILabel *unreadLabel;
@end
@implementation XLConversationTableViewCell

+ (id)CellWithTableView:(UITableView *)tableView{
    XLConversationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XLConversationTableViewCell class])];
    if (!cell) {
        cell = [[XLConversationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([XLConversationTableViewCell class])];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.userHeadImageView = [[UIImageView alloc]init];
        self.userHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.userHeadImageView.backgroundColor = [UIColor redColor];
        self.userHeadImageView.layer.masksToBounds = YES;
        self.userHeadImageView.layer.cornerRadius = 20.0;
        self.nameLabel = [UILabel labelWithColor:[UIColor blackColor] font:[UIFont systemFontOfSize:16.0] alignment:NSTextAlignmentLeft];
        self.updateLabel = [UILabel labelWithColor:[UIColor blackColor] font:[UIFont systemFontOfSize:12.0] alignment:NSTextAlignmentRight];
        self.messageLabel = [UILabel labelWithColor:[UIColor blackColor] font:[UIFont systemFontOfSize:12.0] alignment:NSTextAlignmentLeft];
        self.unreadLabel =[UILabel labelWithColor:[UIColor redColor] font:[UIFont systemFontOfSize:12.0] alignment:NSTextAlignmentRight];
        [self.contentView addSubview:self.userHeadImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.updateLabel];
        [self.contentView addSubview:self.messageLabel];
        [self.contentView addSubview:self.unreadLabel];
        [self.userHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(10.0);
            make.width.height.mas_equalTo(40.0);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.userHeadImageView.mas_top);
            make.left.mas_equalTo(self.userHeadImageView.mas_right).mas_offset(10.0);
        }];
        [self.updateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).mas_equalTo(-10.0);
            make.top.mas_equalTo(self.userHeadImageView.mas_top);
        }];
        [self.unreadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(self.updateLabel.mas_bottom).mas_equalTo(5.0);
        }];
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_left);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(10.0);
            make.right.mas_equalTo(self.unreadLabel.mas_left).mas_equalTo(-5.0);
        }];
    }
    return self;
}

-(void)InitDataViewModel:(XLConversationModel *)model{
    self.nameLabel.text = model.nickname;
    self.updateLabel.text = model.updated_at;
    self.messageLabel.text = model.signature;
    self.unreadLabel.text = [NSString stringWithFormat:@"未读消息数:%@",model.badgeValue];
    [self.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:model.head_img] placeholderImage:[UIImage imageNamed:@"avatar"]];
}

@end
