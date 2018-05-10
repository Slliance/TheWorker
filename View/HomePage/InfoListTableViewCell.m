//
//  InfoListTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/10.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "InfoListTableViewCell.h"

@implementation InfoListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initCell:(ArticleModel *)model{
    if (model.show_img) {
        [self.infoImageView setImageWithString:model.show_img placeHoldImageName:placeholderImage_home_banner];
    }else{
        [self.infoImageView setImageWithString:model.img placeHoldImageName:placeholderImage_home_banner];
    }
    
//    [self.infoImageView setImageWithURL:[NSURL URLWithString:model.show_img] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
    self.labelTime.text = model.createtime;
    self.labelTitle.text = model.title;
    [self.btnWatch setTitle:[NSString stringWithFormat:@"%@次",model.click_count] forState:UIControlStateNormal];
}

@end
