//
//  SaleRecordTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "SaleRecordTableViewCell.h"

@implementation SaleRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCellWithData:(SaleRecordModel *)model{
    self.labelTime.text = model.createtime;
//    self.labelState.text
    switch ([model.trade_type integerValue]) {
        case 0:
            self.labelState.text = @"提现";
            self.labelAmount.text = [NSString stringWithFormat:@"-%@",model.amount];
            break;
        case 1:
            self.labelState.text = @"提现";
            self.labelAmount.text = [NSString stringWithFormat:@"-%@",model.amount];
            break;
        case 2:
            self.labelState.text = @"消费";
            self.labelAmount.text = [NSString stringWithFormat:@"-%@",model.amount];
            break;
        case 3:
            self.labelState.text = @"充值";
            self.labelAmount.text = [NSString stringWithFormat:@"+%@",model.amount];
            break;
        case 4:
            self.labelState.text = @"租缘收入";
            self.labelAmount.text = [NSString stringWithFormat:@"+%@",model.amount];
            break;
        case 5:
            self.labelState.text = @"购物退款";
            self.labelAmount.text = [NSString stringWithFormat:@"+%@",model.amount];
            break;
        case 6:
            self.labelState.text = @"租缘退款";
            self.labelAmount.text = [NSString stringWithFormat:@"+%@",model.amount];
            break;
        case 7:
            self.labelState.text = @"提现返回";
            self.labelAmount.text = [NSString stringWithFormat:@"+%@",model.amount];
            break;
        case 8:
            self.labelState.text = @"入职奖励";
            self.labelAmount.text = [NSString stringWithFormat:@"+%@",model.amount];
            break;
        case 9:
            self.labelState.text = @"入职奖励分成";
            self.labelAmount.text = [NSString stringWithFormat:@"+%@",model.amount];
            break;
        default:
            break;
    }
    self.labelRemainAmount.text = [NSString stringWithFormat:@"余额：%@",model.remain_amount];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
