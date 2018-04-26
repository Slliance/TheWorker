//
//  MyTeamTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 14/12/2017.
//  Copyright © 2017 huying. All rights reserved.
//

#import "MyTeamTableViewCell.h"

@implementation MyTeamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCellWithData:(MyTeamModel *)model type:(NSInteger)type{
    self.mobileLabel.text = model.mobile;
    self.registerTimelabel.text = [NSString stringWithFormat:@"注册时间：%@", model.createtime];
    if (type == 1) {
        self.amountLabel.text = [NSString stringWithFormat:@"已推荐人数：%@人",model.num];
        self.imgMore.hidden = NO;
    }else{
        self.amountLabel.text = [NSString stringWithFormat:@"由%@推荐",model.pmobile];
        self.imgMore.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
