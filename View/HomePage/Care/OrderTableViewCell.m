//
//  OrderTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/22.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initViewWithData:(NSArray *)array{
    NSDictionary *propertyDic = [[NSDictionary alloc]initWithDictionary:array[1]];
    NSInteger num = [propertyDic[@"count"] integerValue];

    StoreGoodsModel *goodsModel = array[0];
    self.goodsNameLabel.text = goodsModel.name;
    [self.goodsImgView setImageWithString:goodsModel.show_img placeHoldImageName:@"bg_no_pictures"];
//    [self.goodsImgView setImageWithURL:[NSURL URLWithString:goodsModel.show_img] placeholderImage:[UIImage imageNamed:placeholderImage_home_banner]];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",[propertyDic[@"price"] floatValue]];
    self.numberLabel.text = [NSString stringWithFormat:@"x%ld",(long)num];
    NSArray *nameArr = array[1][@"name"];
    NSArray *propertyArr = array[1][@"property_name"];
    NSString *propertyStr = @"";
    
    for (int i = 0; i < propertyArr.count; i ++) {
        NSString *str = [NSString stringWithFormat:@"%@：%@",nameArr[i],propertyArr[i]];
        propertyStr = [propertyStr stringByAppendingString:str];
        propertyStr = [propertyStr stringByAppendingString:@" "];
    }
    self.propertyOneLabel.text = propertyStr;
    CGSize size = [propertyStr sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth - 130, 200)];
    CGRect rect = self.propertyOneLabel.frame;
    rect.size.height = size.height;
    self.propertyOneLabel.frame = rect;
}

-(void)initViewWith:(StoreGoodsModel *)model{
    self.goodsNameLabel.text = model.name;
    [self.goodsImgView setImageWithString:model.show_img placeHoldImageName:@"bg_no_pictures"];
//    [self.goodsImgView setImageWithURL:[NSURL URLWithString:model.show_img] placeholderImage:[UIImage imageNamed:placeholderImage_home_banner]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.price floatValue]];
    self.numberLabel.text = [NSString stringWithFormat:@"x%@",model.goods_number];

    NSString *perpertystr = @"";
    for (int i = 0; i < model.property_tag.count; i ++) {
        perpertystr = [perpertystr stringByAppendingString:model.property_tag[i]];
        perpertystr = [perpertystr stringByAppendingString:@"    "];
    }
    self.propertyOneLabel.text = perpertystr;
    CGSize size = [perpertystr sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth - 130, 200)];
    CGRect rect = self.propertyOneLabel.frame;
    rect.size.height = size.height;
    self.propertyOneLabel.frame = rect;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+(CGFloat)getCellHeightWithModel:(StoreGoodsModel *)model{
    float height = 60;
    NSString *perpertystr = @"";
    for (int i = 0; i < model.property_tag.count; i ++) {
        perpertystr = [perpertystr stringByAppendingString:model.property_tag[i]];
        perpertystr = [perpertystr stringByAppendingString:@"    "];
    }
    CGSize size = [perpertystr sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth - 130, 200)];
    height += size.height;
    if (height < 100) {
        height = 100;
    }
    return height;
}
+(CGFloat)getCellHeightWithArray:(NSArray *)array{
    float height = 60;    
    NSArray *nameArr = array[1][@"name"];
    NSArray *propertyArr = array[1][@"property_name"];
    NSString *propertyStr = @"";
    
    for (int i = 0; i < propertyArr.count; i ++) {
        NSString *str = [NSString stringWithFormat:@"%@：%@",nameArr[i],propertyArr[i]];
        propertyStr = [propertyStr stringByAppendingString:str];
        propertyStr = [propertyStr stringByAppendingString:@" "];
    }
    CGSize size = [propertyStr sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth - 130, 200)];
    height += size.height;
    if (height < 100) {
        height = 100;
    }
    return height;
}
@end
