
//
//  ChooseGoodsDetailInfoTableViewCell.m
//  TheWorker
//
//  Created by yanghao on 9/27/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "ChooseGoodsDetailInfoTableViewCell.h"

@implementation ChooseGoodsDetailInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)initCellWithData:(NSString *)str{
    self.labelTitle.text = str;
}
@end
