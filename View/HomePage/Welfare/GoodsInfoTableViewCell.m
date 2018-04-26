//
//  GoodsInfoTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/16.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "GoodsInfoTableViewCell.h"

@implementation GoodsInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCellWithData:(GoodsModel *)model{
//    if ([model.friend_amount integerValue] == 0) {
        self.labelPrice.text = [NSString stringWithFormat:@"%@积分",model.point];
//    }else{
//        self.labelPrice.text = [NSString stringWithFormat:@"%@积分 %@聚友值",model.point,model.friend_amount];
//    }
    self.labelGoodsName.text = model.name;
    self.labelCount.text = [NSString stringWithFormat:@"库存：%@",model.sku];;
    self.labelConvertTime.text = [NSString stringWithFormat:@"兑换时间：%@",model.exchange_time];
    self.labelConvertAddress.text = [NSString stringWithFormat:@"兑换地点：%@",model.address];;
    self.labelConverted.text = [NSString stringWithFormat:@"已兑换：%@",model.exchanged_count];
    CGSize sizeAddress = [self.labelConvertAddress.text sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth-20, 300)];
    CGRect rectAddress = self.labelConvertAddress.frame;
    rectAddress.size.height = sizeAddress.height;
    self.labelConvertAddress.frame = rectAddress;
    CGRect rectTime = self.labelConvertTime.frame;
    rectTime.origin.y = rectAddress.size.height + rectAddress.origin.y + 5;
    
    self.labelConvertTime.frame = rectTime;
    CGSize size = [self.labelPrice.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(200, 100)];
    CGRect rectPrice = self.labelPrice.frame;
    rectPrice.size.width = size.width;
    self.labelPrice.frame = rectPrice;
    CGRect rect = self.labelCount.frame;
    rect.origin.x = size.width+20;
    self.labelCount.frame = rect;
    CGRect rectConvert = self.labelConverted.frame;
    rectConvert.origin.x = rect.origin.x+rect.size.width + 10;
    self.labelConverted.frame = rectConvert;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
