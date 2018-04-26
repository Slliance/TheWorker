//
//  GoodsDetailTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/21.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "GoodsDetailTableViewCell.h"

@implementation GoodsDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCellWithData:(StoreGoodsModel *)model{
    self.labelName.text = model.name;
    self.labelPrice.text = [NSString stringWithFormat:@"￥%.2f",[model.price floatValue]];
    self.labelPriceDelete.text = [NSString stringWithFormat:@"￥%.2f",[model.original_price floatValue]];
    self.labelCount.text = [NSString stringWithFormat:@"库存：%@",model.sku];
    self.labelConverted.text = [NSString stringWithFormat:@"销量：%@",model.sales_volume];
    NSString *oldPrice = self.labelPriceDelete.text;
    NSUInteger length = [oldPrice length];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(0, length)];
    [self.labelPriceDelete setAttributedText:attri];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
