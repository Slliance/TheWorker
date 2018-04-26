//
//  RentChooseTimeTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RentChooseTimeTableViewCell.h"

@implementation RentChooseTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.btnPlus setBackgroundColor:[UIColor colorWithHexString:@"ef5f7d"]];
}
-(void)initCellWithData{
    self.labelTime.text = @"约见时长（单位：小时）";
    NSString *str = self.labelTime.text;
    NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc]initWithString:str];
    //    NSRange redRangeTwo = ;
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"999999"] range:NSMakeRange(4, 7)];
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(4, 7)];
    [self.labelTime setAttributedText:noteStr];
    [self.labelTime sizeToFit];
    self.btnMinus.layer.masksToBounds = YES;
    self.btnMinus.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    self.btnMinus.layer.cornerRadius = 5.f;
    self.btnMinus.layer.borderWidth = 1.f;
    self.btnPlus.layer.masksToBounds = YES;
    self.btnPlus.layer.cornerRadius = 5.f;
}
- (IBAction)minusAction:(id)sender {
    NSInteger count = [self.labelAmount.text integerValue];
    if (count < 1) {
        return;
    }
    count -= 1;
    self.labelAmount.text = [NSString stringWithFormat:@"%ld",(long)count];
    self.returnBlock(self.labelAmount.text);
}
- (IBAction)plusAction:(id)sender {
    NSInteger count = [self.labelAmount.text integerValue];
    if (count == 99) {
        return;
    }
    count += 1;
    self.labelAmount.text = [NSString stringWithFormat:@"%ld",(long)count];
    self.returnBlock(self.labelAmount.text);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
