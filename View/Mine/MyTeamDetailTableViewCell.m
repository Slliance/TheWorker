//
//  MyTeamDetailTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 15/12/2017.
//  Copyright © 2017 huying. All rights reserved.
//

#import "MyTeamDetailTableViewCell.h"

@implementation MyTeamDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCellWithData:(MyTeamModel *)model{
    self.mobileLabel.text = model.mobile;
    self.registerTimeLabel.text = [NSString stringWithFormat:@"注册时间：%@",model.createtime];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
