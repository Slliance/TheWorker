//
//  WithdrawRecordTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WithdrawRecordTableViewCell.h"

@implementation WithdrawRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCellWithData:(SaleRecordModel *)model{
    self.labelCardNO.text = [NSString stringWithFormat:@"%@",model.account];
    self.labelTime.text = model.updatetime;
    self.labelMoney.text = [NSString stringWithFormat:@"%@元",model.amount];
    switch ([model.status integerValue]) {
        case 0:
            self.labelState.text = @"审核中";
            self.labelState.textColor = [UIColor colorWithHexString:@"ff6666"];
            break;
        case 1:
            self.labelState.text = @"已通过";
            self.labelState.textColor = [UIColor colorWithHexString:@"666666"];
            break;
        case 2:
            self.labelState.text = @"已退回";
            self.labelState.textColor = [UIColor colorWithHexString:@"6398f1"];
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
