//
//  MyCouponGetTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/8.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyCouponGetTableViewCell.h"

@implementation MyCouponGetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCellWithDataType:(CouponModel *)model{
    [self.btnGet.layer setMasksToBounds:YES];
    [self.btnGet.layer setCornerRadius:11.5f];
    
    self.labelMoney.text = [NSString stringWithFormat:@"%@元",model.price];
    self.labelName.text = model.name;
    self.labelTime.text = [NSString stringWithFormat:@"%@-%@",model.start_time,model.end_time];

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
