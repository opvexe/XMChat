//
//  XLBaseTableViewCell.m
//  XLIM
//
//  Created by Facebook on 2017/11/21.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "XLBaseTableViewCell.h"

@implementation XLBaseTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
        [self WY_initConfingViews];
        
        
        [self WY_ConfigSignalDataSoucre];
        
    }
    return  self ;
}


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self WY_initConfingViews];
    
    
    [self WY_ConfigSignalDataSoucre];
    
    
}
-(void)WY_initConfingViews{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
-(void)WY_SetupViewModel{
    
}
-(void)WY_ConfigSignalDataSoucre{
    
    
}

-(void)InitDataViewModel:(WY_BaseModel *)model{
    
    
}

+ (id)CellWithTableView:(UITableView *)tableview{
        return nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
+(CGFloat)getCellHeight:(WY_BaseModel *)model{
    
    return 0;
}

@end
