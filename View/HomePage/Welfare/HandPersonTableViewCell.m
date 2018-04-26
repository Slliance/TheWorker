//
//  HandPersonTableViewCell.m
//  TheWorker
//
//  Created by yanghao on 8/23/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "HandPersonTableViewCell.h"

@implementation HandPersonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.f;
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 33.f;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initCell:(HandInModel *)model{
    CGSize size = [model.nickname sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(300, 20)];
//    [self.nameBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateDisabled];
    CGRect rectName = self.nameLabel.frame;
    rectName.size.width = size.width;
    self.nameLabel.frame = rectName;
    CGRect rect = self.imgViewSex.frame;
    rect.origin.x = rectName.origin.x + size.width + 10.f;
    self.imgViewSex.frame = rect;
    self.nameLabel.text = model.nickname;
//    [self.nameBtn setTitle:model.nickname forState:UIControlStateDisabled];
    self.labelContent.text = model.declaration;
    [self.headImgView setImageWithString:model.headimg placeHoldImageName:placeholderImage_user_headimg];
//    [self.headImgView setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:placeholderImage_home_banner]];
    if ([model.sex integerValue] == 0) {
        self.imgViewSex.image = [UIImage imageNamed:@"icon_gules_female_sex"];
    }else if([model.sex integerValue] == 1){
        self.imgViewSex.image = [UIImage imageNamed:@"icon_gules_male_sex"];
    }else{
        self.imgViewSex.hidden = YES;
    }
    
    
}
@end
