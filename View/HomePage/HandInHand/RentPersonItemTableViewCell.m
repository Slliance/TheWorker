//
//  RentPersonItemTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RentPersonItemTableViewCell.h"

@implementation RentPersonItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCellWithData:(BOOL)isSelect model:(SkillModel *)model{
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@元/小时",model.price];
    if (isSelect) {
        self.imgSelected.image = [UIImage imageNamed:@"btn_box_selected"];
    }else{
        self.imgSelected.image = [UIImage imageNamed:@"btn_box_no_selected"];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
