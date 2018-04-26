//
//  ChooseAreaTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/18.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ChooseAreaTableViewCell.h"

@implementation ChooseAreaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCellWithData:(NSString *)str{
    self.titleLabel.text = str;
    // 禁用SelectionStyle
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.bgView.backgroundColor = [UIColor greenColor];
}


// 配置cell高亮状态
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
//    if (highlighted) {
//        self.contentView.backgroundColor = [UIColor colorWithHexString:@"0xcccccc"];
//    } else {
//        // 增加延迟消失动画效果，提升用户体验
//        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.contentView.backgroundColor = [UIColor whiteColor];
//        } completion:nil];
//    }
}

// 配置cell选中状态
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"0xececec"];
        self.testImageView.hidden = NO;
        self.leftLabel.hidden = NO;
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.testImageView.hidden = YES;
        self.leftLabel.hidden = YES;
    }
}

@end
