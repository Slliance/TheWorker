//
//  BrandTableViewCell.m
//  TheWorker
//
//  Created by yanghao on 8/19/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "BrandTableViewCell.h"

@implementation BrandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCellWithData:(PartnerModel *)model{
    [self.logoImageView setImageWithString:model.logo placeHoldImageName:@"bg_no_pictures"];
//    [self.logoImageView setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
    self.labelCompanyName.text = model.name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
