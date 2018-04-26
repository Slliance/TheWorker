//
//  ShippingAddressTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/24.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ShippingAddressTableViewCell.h"

@implementation ShippingAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCellWithData:(AddressModel *)model{
    self.labelName.text = model.name;
    self.labelPhoneNO.text = [NSString stringWithFormat:@"%@",model.mobile];
    self.labelAddress.text = [NSString stringWithFormat:@"%@%@",model.zone_city,model.address_detail];
    CGSize nameSize = [self.labelName.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(150, 200)];
    self.labelName.frame = CGRectMake(10, 10, nameSize.width, 21);
    self.labelPhoneNO.frame = CGRectMake(10+nameSize.width+19, 10, 150, 21);
    if ([model.is_def integerValue] == 1) {
        self.labelDefault.hidden = NO;
        self.labelDefault.layer.masksToBounds = YES;
        self.labelDefault.layer.cornerRadius = 8.f;
        self.labelAddress.frame = CGRectMake(10+30+8, 37, ScreenWidth-48-10, 21);
    }else{
        self.labelAddress.frame = CGRectMake(10, 37, ScreenWidth-20, 21);
        self.labelDefault.hidden = YES;

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
