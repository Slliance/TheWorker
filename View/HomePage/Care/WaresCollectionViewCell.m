//
//  WaresCollectionViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/17.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WaresCollectionViewCell.h"

@implementation WaresCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCellWithData:(StoreGoodsModel *)model{
    self.labelWareName.text = model.name;
    [self.waresImageView setImageWithString:model.show_img placeHoldImageName:@"bg_no_pictures"];
//    [self.waresImageView setImageWithURL:[NSURL URLWithString:model.show_img] placeholderImage:[UIImage imageNamed:placeholderImage_home_banner]];
    self.labelSales.text = [NSString stringWithFormat:@"销量 %@笔",model.sales_volume];
    self.labelPrices.text = [NSString stringWithFormat:@"￥%.2f",[model.price floatValue]];
}
@end
