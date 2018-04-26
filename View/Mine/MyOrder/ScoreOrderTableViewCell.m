//
//  ScoreOrderTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ScoreOrderTableViewCell.h"

@implementation ScoreOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCellWithData:(ScoreOrderModel *)model{
    //    CALayer *cicleLayer = [[CALayer alloc] init];
    
    [self.goodsImage.layer setBorderColor:[UIColor colorWithHexString:@"f0f0f0"].CGColor];
    [self.goodsImage.layer setBorderWidth:1.f];
    
    [self.goodsImage setImageWithString:model.show_img placeHoldImageName:placeholderImage_home_banner];
//    [self.goodsImage setImageWithURL:[NSURL URLWithString:model.show_img]];
    self.labelGoodsName.text = model.name;
    if ([model.status integerValue] == 0) {//订单状态 ：0=待领取，1=已领取，2=全部
        self.labelGoodsState.text = @"待领取";
        self.labelGoodsState.textColor = [UIColor colorWithHexString:@"ff6666"];
    }
    else if ([model.status integerValue] == 1){
        self.labelGoodsState.text = @"已领取";
        self.labelGoodsState.textColor = [UIColor colorWithHexString:@"999999"];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
