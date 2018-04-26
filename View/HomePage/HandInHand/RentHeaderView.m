//
//  RentHeaderView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RentHeaderView.h"

@implementation RentHeaderView

-(void)initViewWith:(RentPersonModel *)model{
    [self.headImage setImageWithString:model.headimg placeHoldImageName:placeholderImage_user_headimg];
//    [self.headImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,model.headimg]] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
    self.nameLabel.text = model.nickname;
    CGSize size = [self.nameLabel.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(200, 100)];
    CGRect rectName = self.nameLabel.frame;
    rectName.size.width = size.width;
    self.nameLabel.frame = rectName;
    CGRect rectSex = self.imageSex.frame;
    rectSex.origin.x = rectName.origin.x + rectName.size.width + 10;
    self.imageSex.frame = rectSex;
    if ([model.sex integerValue] == 0) {
        [self.imageSex setImage:[UIImage imageNamed:@"icon_gules_female_sex"]];
    }else if([model.sex integerValue] == 1){
        [self.imageSex setImage:[UIImage imageNamed:@"icon_gules_male_sex"]];
    }else{
        [self.imageSex setImage:[UIImage imageNamed:@""]];
    }
    self.labelTrust.text = [NSString stringWithFormat:@"信任值：%@",model.trust];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 32.5f;
    self.labelTrust.layer.masksToBounds = YES;
    self.labelTrust.layer.cornerRadius = 9.5f;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
