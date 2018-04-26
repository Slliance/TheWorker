//
//  MyRentPersonTableViewCell.m
//  TheWorker
//
//  Created by yanghao on 9/2/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "MyRentPersonTableViewCell.h"

@implementation MyRentPersonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 37.f;
    [self.nameBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateDisabled];
    
    self.labelTag.textColor = [UIColor colorWithHexString:@"ef5f7d"];
    self.labelContent.textColor = [UIColor colorWithHexString:@"666666"];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initCellWith:(RentOrderModel *)model{
    [self.nameBtn setTitle:model.nickname forState:UIControlStateDisabled];
    [self.headImgView setImageWithString:model.headimg placeHoldImageName:placeholderImage_user_headimg];
//    [self.headImgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,model.headimg]] placeholderImage:[UIImage imageNamed:placeholderImage_home_banner]];
    if ([model.sex integerValue] == 0) {
        [self.imgViewSex setImage:[UIImage imageNamed:@"icon_gules_female_sex"]];
    }else if ([model.sex integerValue] == 1){
        [self.imgViewSex setImage:[UIImage imageNamed:@"icon_gules_male_sex"]];
    }else{
        [self.imgViewSex setImage:[UIImage imageNamed:@""]];
    }
    if (model.start_time.length > 5) {
        NSString *string1 = [model.start_time substringWithRange:NSMakeRange(0, 16)];//截取范围类的字符串
        NSString *string2 = [model.end_time substringWithRange:NSMakeRange(11, 5)];
        self.labelContent.text = [NSString stringWithFormat:@"预约时间：%@-%@",string1,string2];
    }
    self.labelTag.text = [NSString stringWithFormat:@"%@/%@小时",model.item,model.rent_long];
    CGSize size = [self.nameBtn.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(300, 20)];
    CGRect rectBtn = self.nameBtn.frame;
    rectBtn.size.width = size.width;
    self.nameBtn.frame = rectBtn;
    CGRect rect = self.imgViewSex.frame;
    rect.origin.x = rectBtn.origin.x + rectBtn.size.width + 5.f;
    self.imgViewSex.frame = rect;
    
}
@end
