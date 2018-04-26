//
//  CardListTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "CardListTableViewCell.h"

@implementation CardListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCellWithData:(WalletModel *)model{
    self.labelCardNum.text = [NSString stringWithFormat:@"%@",model.card];
    self.labelCardName.text = model.name;
}
- (IBAction)chooseAction:(id)sender {
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
