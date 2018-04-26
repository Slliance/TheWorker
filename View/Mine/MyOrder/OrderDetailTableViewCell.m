//
//  OrderDetailTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "OrderDetailTableViewCell.h"

#define btn_tag_max   999

@implementation OrderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCellWithData:(StoreGoodsModel *)model status:(NSInteger)status{
    self.model = model;
    for (UIButton * btn in self.subviews) {
        if (btn.tag > btn_tag_max) {
            [btn removeFromSuperview];
        }
    }

    [self.btnBuy.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
    [self.btnBuy.layer setBorderWidth:1];
    [self.btnBuy.layer setMasksToBounds:YES];
    [self.btnBuy.layer setCornerRadius:4.f];
    
    
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

    
    CGFloat btn_width = 60.f;
    CGFloat btn_height = 25.f;
    CGFloat point_y = 77.f;
    switch (status) {
        case 1://待付款
        {
        }
            break;
        case 2://待发货
        {
            UIButton *btn = [[UIButton alloc]init];
            btn.frame = CGRectMake(ScreenWidth - (btn_width + 10), point_y, btn_width, btn_height);
            [btn setTitle:@"再次购买" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"f1a036"] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:11]];
            [btn.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
            [btn.layer setBorderWidth:1];
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:4.f];
            btn.tag = btn_tag_max + 1;
            [btn addTarget:self action:@selector(buyAgain:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:btn];
            
        }
            break;
        case 3://待收货
        {
            UIButton *btn = [[UIButton alloc]init];
            btn.frame = CGRectMake(ScreenWidth - (btn_width + 10) * 1, point_y, btn_width, btn_height);
            [btn setTitle:@"再次购买" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"f1a036"] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:11]];
            [btn.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
            [btn.layer setBorderWidth:1];
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:4.f];
            btn.tag = btn_tag_max + 2;

            [btn addTarget:self action:@selector(buyAgain:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:btn];
            
            
        }
            break;
        case 4://已完成
        {
            NSInteger num = 2;
            if ([model.score integerValue] == 0) {
                UIButton *btn1 = [[UIButton alloc]init];
                btn1.frame = CGRectMake(ScreenWidth - (btn_width + 10), point_y, btn_width, btn_height);
                [btn1 setTitle:@"去评价" forState:UIControlStateNormal];
                [btn1 setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                [btn1.titleLabel setFont:[UIFont systemFontOfSize:11]];
                [btn1 setBackgroundColor:[UIColor colorWithHexString:@"f1a036"]];
                [btn1.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
                [btn1.layer setBorderWidth:1];
                [btn1.layer setMasksToBounds:YES];
                [btn1.layer setCornerRadius:4.f];
                btn1.tag = btn_tag_max + 3;

                [btn1 addTarget:self action:@selector(commentOrder:) forControlEvents:UIControlEventTouchUpInside];
                
                [self addSubview:btn1];
                
            }
            else{
                num --;
            }
            
            UIButton *btn = [[UIButton alloc]init];
            btn.frame = CGRectMake(ScreenWidth - (btn_width + 10) * num, point_y, btn_width, btn_height);
            [btn setTitle:@"再次购买" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"f1a036"] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:11]];
            [btn.layer setBorderColor:[UIColor colorWithHexString:@"f1a036"].CGColor];
            [btn.layer setBorderWidth:1];
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:4.f];
            btn.tag = btn_tag_max + 4;

            [btn addTarget:self action:@selector(buyAgain:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:btn];

            
            
            if ([model.refund_status integerValue] != 1) {
                UIButton *btn2 = [[UIButton alloc]init];
                btn2.frame = CGRectMake(ScreenWidth - (btn_width + 10) * (num + 1), point_y, btn_width, btn_height);
                [btn2 setTitle:@"申请售后" forState:UIControlStateNormal];
                [btn2 setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
                [btn2.titleLabel setFont:[UIFont systemFontOfSize:11]];
                [btn2.layer setBorderColor:[UIColor colorWithHexString:@"cccccc"].CGColor];
                [btn2.layer setBorderWidth:1];
                [btn2.layer setMasksToBounds:YES];
                [btn2.layer setCornerRadius:4.f];
                btn2.tag = btn_tag_max + 5;

                [btn2 addTarget:self action:@selector(applySaleService:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn2];

            }
            
        }
            break;
            
        default:
            break;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//再次购买
-(void)buyAgain:(id)sender{
    self.buyAgainBlock(self.model);
}

//去评价
-(void)commentOrder:(id)sender{
    self.commentOrderBlock(self.model);
}

//申请售后
-(void)applySaleService:(id)sender{
    self.applySaleServiceBlock(self.model);
}
@end
