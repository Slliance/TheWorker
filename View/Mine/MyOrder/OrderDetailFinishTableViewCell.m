//
//  OrderDetailTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "OrderDetailFinishTableViewCell.h"

@implementation OrderDetailFinishTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCellWithData:(StoreGoodsModel *)model{
    
    self.goodsNameLabel.text = model.name;
    [self.goodsImgView setImageWithString:model.show_img placeHoldImageName:placeholderImage_home_banner];
//    [self.goodsImgView setImageWithURL:[NSURL URLWithString:model.show_img] placeholderImage:[UIImage imageNamed:placeholderImage_home_banner]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.price floatValue]];
    self.numberLabel.text = [NSString stringWithFormat:@"x%@",model.goods_number];
    
    NSString *perpertystr = @"";
    for (int i = 0; i < model.property_tag.count; i ++) {
        perpertystr = [perpertystr stringByAppendingString:model.property_tag[i]];
        perpertystr = [perpertystr stringByAppendingString:@"    "];
    }
    self.propertyOneLabel.text = perpertystr;

    CGFloat btn_width = 75.f;
    CGFloat point_y = 120;

    //订单是否申请退款
    
    if ([model.refund_status boolValue]) {
        
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 2, point_y, btn_width, 30);
        [btn setTitle:@"再次购买" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"f1a036"] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
        [btn.layer setBorderWidth:1];
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:4.f];
        [btn addTarget:self action:@selector(buyAgain:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bottomView addSubview:btn];

    }
    else{
        UIButton *btn2 = [[UIButton alloc]init];
        btn2.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 3, point_y, btn_width, 30);
        [btn2 setTitle:@"申请售后" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [btn2.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn2.layer setBorderColor:[UIColor colorWithHexString:@"cccccc"].CGColor];
        [btn2.layer setBorderWidth:1];
        [btn2.layer setMasksToBounds:YES];
        [btn2.layer setCornerRadius:4.f];
        [btn2 addTarget:self action:@selector(applySaleService:) forControlEvents:UIControlEventTouchUpInside];
  
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 2, point_y, btn_width, 30);
        [btn setTitle:@"再次购买" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"f1a036"] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
        [btn.layer setBorderWidth:1];
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:4.f];
        [btn addTarget:self action:@selector(buyAgain:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bottomView addSubview:btn];
        
        
        UIButton *btn1 = [[UIButton alloc]init];
        btn1.frame = CGRectMake(ScreenWidth - (btn_width + 10), point_y, btn_width, 30);
        [btn1 setTitle:@"去评价" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [btn1.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn1 setBackgroundColor:[UIColor colorWithHexString:@"f1a036"]];
        [btn1.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
        [btn1.layer setBorderWidth:1];
        [btn1.layer setMasksToBounds:YES];
        [btn1.layer setCornerRadius:4.f];
        [btn1 addTarget:self action:@selector(commentOrder:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bottomView addSubview:btn1];
        [self.bottomView addSubview:btn2];
        
    }
    
    
    
  
    

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
