//
//  OrderNumberTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "OrderNumberTableViewCell.h"

@implementation OrderNumberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCellWithData:(OrderGoodsModel *)model{
    self.labelNo.text = [NSString stringWithFormat:@"%@",model.order_no];
    
    switch ([model.order_status integerValue]) {
        case 1:
        {
            self.labelState.text = @"待付款";
        }
            break;
            
        case 2:
        {
            self.labelState.text = @"待发货";
        }
            break;
            
        case 3:
        {
            self.labelState.text = @"待收货";
        }
            break;
            
        case 4:
        {
            self.labelState.text = @"已完成";
        }
            break;
            
        case 5:
        {
            self.labelState.text = @"售后服务";
            
            if ([model.refund_status integerValue] == 1) {
                
                switch ([model.status integerValue]) {
                    case 0:
                    {
                        self.labelState.text = @"申请中";
                    }
                        break;
                    case 1:
                    {
                        self.labelState.text = @"已通过";
                    }
                        break;
                    case 2:
                    {
                        self.labelState.text = @"驳回";
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            
        }
            break;
        case 6://已完成,不能申请售后
        {
            self.labelState.text = @"已完成";
            
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

@end
