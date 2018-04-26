//
//  MyIntegralTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/24.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyIntegralTableViewCell.h"

@implementation MyIntegralTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCellWithData:(IntegralModel *)model{
    
    self.labelTime.text = model.createtime;
    self.labelScore.text = [NSString stringWithFormat:@"积分：%@", model.remain_score];
    //记录类型：1-签到 2-入职 3-积分兑换  4-聚友值兑换 5-邀请好友聚友值奖励,6-平台赠送，7-注册积分，8-求职信息填写，9-每天第一次发朋友圈，10-租缘吧消费
    switch ([model.score_type integerValue]) {
        case 1:
            self.labelType.text = @"签到";
            self.labelMoney.text = [NSString stringWithFormat:@"+%@", model.score];
            break;
        case 2:
            self.labelType.text = @"入职";
            self.labelMoney.text = [NSString stringWithFormat:@"+%@", model.score];
            break;
        case 3:
            self.labelType.text = @"积分兑换";
            self.labelMoney.text = [NSString stringWithFormat:@"-%@", model.score];
            break;
        case 4:
            self.labelType.text = @"聚友值兑换";
            self.labelMoney.text = [NSString stringWithFormat:@"+%@", model.score];
            break;
        case 5:
            self.labelType.text = @"邀请好友聚友值奖励";
            self.labelMoney.text = [NSString stringWithFormat:@"+%@", model.score];
            break;
        case 6:
            self.labelType.text = @"平台赠送";
            self.labelMoney.text = [NSString stringWithFormat:@"+%@", model.score];
            break;
        case 7:
            self.labelType.text = @"注册积分";
            self.labelMoney.text = [NSString stringWithFormat:@"+%@", model.score];
            break;
        case 8:
            self.labelType.text = @"求职信息填写";
            self.labelMoney.text = [NSString stringWithFormat:@"+%@", model.score];
            break;
        case 9:
            self.labelType.text = @"每天第一次发朋友圈";
            self.labelMoney.text = [NSString stringWithFormat:@"+%@", model.score];
            break;
        case 10:
            self.labelType.text = @"租缘吧消费";
            self.labelMoney.text = [NSString stringWithFormat:@"+%@", model.score];
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
