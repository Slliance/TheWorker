//
//  MyCartTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyCartTableViewCell.h"

@implementation MyCartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews
{

//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = UIColorFromRGB(0xffffff);
//    self.selectedBackgroundView = view;
//    [self.btnPlus setBackgroundColor:[UIColor colorWithHexString:@"6398f1"]];
//
////    UIView *view = [[UIView alloc] init];
////    view.backgroundColor = UIColorFromRGB(0xffffff);
////    self.selectedBackgroundView = view;
//    
//
//    for (UIControl *control in self.subviews){
//        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
//            for (UIView *view in control.subviews)
//            {
//                if ([view isKindOfClass: [UIImageView class]]) {
//                    UIImageView *image=(UIImageView *)view;
//                    if (self.selected) {
//                        image.image=[UIImage imageNamed:@"icon_circle_selected"];
//                    }
//                    else
//                    {
//                        image.image=[UIImage imageNamed:@"icon_circle_not_selected"];
//                    }
//                }
//            }
//        }
//    }
    
    [super layoutSubviews];
}

-(void)initCellWithData:(StoreGoodsModel *)model{
    self.storeGoodsModel = model;
    self.btnMinus.layer.masksToBounds = YES;
    self.btnMinus.layer.cornerRadius = 4.f;
    [self.btnMinus.layer setBorderColor:[UIColor colorWithHexString:@"e6e6e6"].CGColor];
    [self.btnMinus.layer setBorderWidth:1];
    self.btnPlus.layer.masksToBounds = YES;
    self.btnPlus.layer.cornerRadius = 4.f;
    self.goodsImg.layer.borderColor = [UIColor colorWithHexString:@"f0f0f0"].CGColor;
    self.goodsImg.layer.borderWidth = 1;
    NSArray *propertyArr = model.property;
    NSString *propertyStr = @"";
    for (int i = 0; i < propertyArr.count; i ++) {
        propertyStr = [propertyStr stringByAppendingString:[NSString stringWithFormat:@" %@",propertyArr[i]]];
    }
    self.labelProperty.text = propertyStr;
    self.shopId = model.Id;
    if([model.sku integerValue]){
        self.labelAmount.text = [NSString stringWithFormat:@"库存：%@",model.sku];
        self.btnMinus.hidden = NO;
        self.btnPlus.hidden = NO;
        self.labelAmount.hidden = NO;
    }
    else{
        self.labelAmount.text = @"库存不足";
        self.btnMinus.hidden = YES;
        self.btnPlus.hidden = YES;
        self.labelAmount.hidden = NO;
        self.labelCount.hidden = YES;
    }
    self.maxCount = [model.sku integerValue];
    self.goodsName.text = model.name;
    [self.goodsImg setImageWithString:model.show_img placeHoldImageName:placeholderImage_home_banner];
//    [self.goodsImg setImageWithURL:[NSURL URLWithString:model.show_img] placeholderImage:[UIImage imageNamed:placeholderImage_home_banner]];
    self.labelPrice.text = [NSString stringWithFormat:@"￥%.2f",[model.price floatValue]];
    self.labelCount.text = [NSString stringWithFormat:@"%@",model.goods_number];
    
    if ([self.labelCount.text integerValue] != 1) {
        [self.btnMinus setBackgroundColor:[UIColor colorWithHexString:@"6398f1"]];
        [self.btnMinus setImage:[UIImage imageNamed:@"icon_white_minus_sign"] forState:UIControlStateNormal];
    }
}
- (IBAction)minusAction:(id)sender {
    NSInteger count = [self.labelCount.text integerValue];
    if (count == 1 || ![self.storeGoodsModel.sku integerValue]) {
        return;
    }
    else {
        if (count == 2) {
            [self.btnMinus setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
            [self.btnMinus setImage:[UIImage imageNamed:@"icon_minus_sign"] forState:UIControlStateNormal];

        }
        self.returnBlock(count, count - 1, self.shopId);
    }
    self.labelCount.text = [NSString stringWithFormat:@"%ld",count - 1];
}

- (IBAction)plusAction:(id)sender {
    NSInteger count = [self.labelCount.text integerValue];
    if (count != self.maxCount || ![self.storeGoodsModel.sku integerValue]) {
        self.returnBlock(count, count + 1, self.shopId);
        [self.btnMinus setBackgroundColor:[UIColor colorWithHexString:@"6398f1"]];
        [self.btnMinus setImage:[UIImage imageNamed:@"icon_white_minus_sign"] forState:UIControlStateNormal];
        self.labelCount.text = [NSString stringWithFormat:@"%ld",count + 1];
    }
    else{
        self.msgBlock(@"库存不足");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectBtn:(id)sender {
}
@end
