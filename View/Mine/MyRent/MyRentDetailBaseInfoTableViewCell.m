//
//  MyRentDetailBaseInfoTableViewCell.m
//  TheWorker
//
//  Created by yanghao on 9/2/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "MyRentDetailBaseInfoTableViewCell.h"

@implementation MyRentDetailBaseInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImgView.layer.masksToBounds = YES;
    self.headImgView.layer.cornerRadius = 37.f;
    [self.nameBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateDisabled];
    
    self.labelPhone.textColor = [UIColor colorWithHexString:@"666666"];
    self.labelScore.textColor = [UIColor colorWithHexString:@"666666"];

    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)initCellWith:(RentOrderModel *)model{
    NSNumber *point = [[NSNumber alloc] init];
    if ([model.type integerValue] == 1) {
        point = model.rent_point;
        self.labelTitle.text = @"出租人信息";
        self.labelPhone.text = [NSString stringWithFormat:@"电话：%@",model.mobile];
    }else{
        point = model.user_point;
        self.labelTitle.text = @"预约人信息";
        self.labelPhone.text = [NSString stringWithFormat:@"电话：%@",model.lnk_mobile];
        
    }
    [self.nameBtn setTitle:model.nickname forState:UIControlStateDisabled];
    [self.headImgView setImageWithString:model.headimg placeHoldImageName:placeholderImage_user_headimg];    
    if ([model.sex integerValue] == 0) {
        [self.imgViewSex setImage:[UIImage imageNamed:@"icon_gules_female_sex"]];
    }else if ([model.sex integerValue] == 1){
        [self.imgViewSex setImage:[UIImage imageNamed:@"icon_gules_male_sex"]];
    }else{
        [self.imgViewSex setImage:[UIImage imageNamed:@""]];
    }
    
    CGSize size = [self.nameBtn.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(150, 20)];
    CGRect rectName = self.nameBtn.frame;
    rectName.size.width = size.width;
    self.nameBtn.frame = rectName;
    CGRect rect = self.imgViewSex.frame;
    rect.origin.x = self.nameBtn.frame.origin.x + size.width + 10.f;
    self.imgViewSex.frame = rect;
    if ([model.type integerValue] == 1) {
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:
                                              [NSString stringWithFormat:@"出租人评分：%@分",point]];
        NSRange redRange = NSMakeRange(6, noteStr.length - 6);
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ff6666"] range:redRange];
        
        self.labelScore.attributedText = noteStr;
    }else{
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:
                                              [NSString stringWithFormat:@"预约人评分：%@分",point]];
        NSRange redRange = NSMakeRange(6, noteStr.length - 6);
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ff6666"] range:redRange];
        
        self.labelScore.attributedText = noteStr;
    }
    
    
 
    
    
    
}
@end
