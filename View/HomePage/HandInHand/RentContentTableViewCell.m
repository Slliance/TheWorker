//
//  RentContentTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RentContentTableViewCell.h"

@implementation RentContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCellWithData:(BOOL)confirmed{
    if (confirmed) {
        CGRect rect = self.labelContent.frame;
        rect.origin.x = rect.origin.x - 15;
        self.labelContent.frame = rect;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
