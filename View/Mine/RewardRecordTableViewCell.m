//
//  RewardRecordTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/5.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RewardRecordTableViewCell.h"

@implementation RewardRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCellWithData:(RewardModel *)model{
    self.amountLabel.text = [NSString stringWithFormat:@"+%@",model.amount];
    self.remainAmountLabel.text = [NSString stringWithFormat:@"余额：%@",model.remain_amount];
    self.timeLabel.text = model.createtime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
