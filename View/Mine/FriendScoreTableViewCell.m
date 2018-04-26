//
//  FriendScoreTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/5.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "FriendScoreTableViewCell.h"

@implementation FriendScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCellWithData:(IntegralModel *)model{
    self.mobileLabel.text = [NSString stringWithFormat:@"%@",model.mobile];
    self.friendAmountLabel.text = [NSString stringWithFormat:@"+%@",model.friend_amount];
    self.timeLabel.text = model.createtime;
    self.scoreLabelOne.text = [NSString stringWithFormat:@"积分 +%@",model.score];

    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:self.scoreLabelOne.text];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(0, 2)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 2)];
    [self.scoreLabelOne setAttributedText:attStr];
//    [self.scoreLabelOne sizeToFit];
//    self.scoreLabelOne.textAlignment = NSTextAlignmentRight;
//        CGSize size = [self.scoreLabelOne.text sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(100, 20)];
//    CGRect rect = self.scoreLabelOne.frame;
//    rect.size.width = size.width;
//    rect.origin.x = ScreenWidth - size.width - 10;
//    self.scoreLabelOne.frame = rect;
////    CGRect scoreRect = self.scoreLabel.frame;
////    scoreRect.origin.x = rect.origin.x - 10 - scoreRect.size.width;
////    self.scoreLabel.frame = scoreRect;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
