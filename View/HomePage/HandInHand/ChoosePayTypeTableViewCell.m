//
//  ChoosePayTypeTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ChoosePayTypeTableViewCell.h"

@implementation ChoosePayTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCellWithData:(NSInteger)row :(BOOL)isSelect money:(NSNumber *)money{
//    icon_red_selected
    if (isSelect) {
        self.selectedImg.image = [UIImage imageNamed:@"icon_red_selected"];
    }else{
        self.selectedImg.image = [UIImage imageNamed:@"icon_circle_not_selected"];
    }
    switch (row) {
        case 0:
        {
            self.typeImageView.image = [UIImage imageNamed:@"icon_purse_balance"];
            self.labelPayType.text = [NSString stringWithFormat:@"余额支付(余额：%.2f)",[money doubleValue]];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:self.labelPayType.text];
            [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(4, self.labelPayType.text.length-4)];
            [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(4, self.labelPayType.text.length-4)];
            [self.labelPayType setAttributedText:attStr];
            [self.labelPayType sizeToFit];
            break;
        }
        case 1:
            self.typeImageView.image = [UIImage imageNamed:@"pay_treasure"];
            self.labelPayType.text = @"支付宝";
            break;
        case 2:
            self.typeImageView.image = [UIImage imageNamed:@"icon_wechat_payment"];
            self.labelPayType.text = @"微信";
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
