//
//  RentPersonFansTableViewCell.m
//  TheWorker
//
//  Created by yanghao on 8/23/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "RentPersonFansTableViewCell.h"
@implementation RentPersonFansTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 23.f;
    // Initialization code
}

-(void)initCellWith:(FansModel *)model{
    [self.headImgView setImageWithString:model.headimg placeHoldImageName:placeholderImage_user_headimg];
//    [self.headImgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,model.headimg]] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
    self.nameLabel.text = model.nickname;
    self.createTimeLabel.text = model.createtime;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
