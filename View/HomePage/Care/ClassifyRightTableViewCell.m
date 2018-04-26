//
//  ClassifyRightTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/22.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ClassifyRightTableViewCell.h"

@implementation ClassifyRightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.selected == YES) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.labelGoodsName.textColor = [UIColor colorWithHexString:@"6398f1"];
    }else{
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        self.labelGoodsName.textColor = [UIColor colorWithHexString:@"333333"];
    }

    // Configure the view for the selected state
}

@end
