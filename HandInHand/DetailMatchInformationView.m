//
//  DetailMatchInformationView.m
//  TheWorker
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "DetailMatchInformationView.h"

@implementation DetailMatchInformationView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setContentLayout];
    }
    return self;
}

-(void)setContentLayout{
    [self addSubview:self.nikeImage];
    [self addSubview:self.nikeNameLabel];
    [self addSubview:self.detailNikeNameLabel];
    [self addSubview:self.sexImage];
    [self addSubview:self.sexLabel];
    [self addSubview:self.detailSexLabel];
    [self addSubview:self.birthdayImage];
    [self addSubview:self.birthdayLabel];
    [self addSubview:self.detailBirthdayLabel];
    [self addSubview:self.heightImage];
    [self addSubview:self.heightLabel];
    [self addSubview:self.detailHeightLabel];
    [self addSubview:self.incomeImage];
    [self addSubview:self.incomeLabel];
    [self addSubview:self.detailIncomeLabel];
    [self addSubview:self.addressImage];
    [self addSubview:self.addressLabel];
    [self addSubview:self.detailAddressLabel];
    [self addSubview:self.marriageImage];
    [self addSubview:self.marriageLabel];
    [self addSubview:self.detailMarriageLabel];
    [self.nikeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self).offset(19);
        make.width.height.mas_equalTo(17);
    }];
    [self.nikeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nikeImage.mas_right).offset(10);
        make.centerY.equalTo(self.nikeImage);
        make.width.mas_equalTo(78);
    }];
    [self.nikeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nikeNameLabel.mas_right).offset(10);
        make.centerY.equalTo(self.nikeImage);
        make.right.equalTo(self).offset(12);
    }];
    [self.sexImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self.nikeImage.mas_bottom).offset(20);
        make.width.height.mas_equalTo(17);
    }];
    [self.sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sexImage.mas_right).offset(10);
        make.centerY.equalTo(self.sexImage);
        make.width.mas_equalTo(78);
    }];
    [self.detailSexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sexLabel.mas_right).offset(10);
        make.centerY.equalTo(self.sexImage);
        make.right.equalTo(self).offset(12);
    }];
    [self.birthdayImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self.sexImage.mas_bottom).offset(20);
        make.width.height.mas_equalTo(17);
    }];
    [self.birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.birthdayImage.mas_right).offset(10);
        make.centerY.equalTo(self.birthdayImage);
        make.width.mas_equalTo(78);
    }];
    [self.detailBirthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.birthdayLabel.mas_right).offset(10);
        make.centerY.equalTo(self.birthdayImage);
        make.right.equalTo(self).offset(12);
    }];
    [self.heightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self.birthdayImage.mas_bottom).offset(20);
        make.width.height.mas_equalTo(17);
    }];
    [self.heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.birthdayImage.mas_right).offset(10);
        make.centerY.equalTo(self.heightImage);
        make.width.mas_equalTo(78);
    }];
    [self.detailHeightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.heightLabel.mas_right).offset(10);
        make.centerY.equalTo(self.heightImage);
        make.right.equalTo(self).offset(12);
    }];
    [self.incomeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self.heightImage.mas_bottom).offset(20);
        make.width.height.mas_equalTo(17);
    }];
    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.incomeImage.mas_right).offset(10);
        make.centerY.equalTo(self.incomeImage);
        make.width.mas_equalTo(78);
    }];
    [self.detailIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.incomeLabel.mas_right).offset(10);
        make.centerY.equalTo(self.incomeImage);
        make.right.equalTo(self).offset(12);
    }];
    [self.addressImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self.incomeImage.mas_bottom).offset(20);
        make.width.height.mas_equalTo(17);
    }];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressImage.mas_right).offset(10);
        make.centerY.equalTo(self.addressImage);
        make.width.mas_equalTo(78);
    }];
    [self.detailAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressLabel.mas_right).offset(10);
        make.centerY.equalTo(self.addressImage);
        make.right.equalTo(self).offset(12);
    }];
    [self.marriageImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self.addressImage.mas_bottom).offset(20);
        make.width.height.mas_equalTo(17);
    }];
    [self.marriageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.marriageImage.mas_right).offset(10);
        make.centerY.equalTo(self.marriageImage);
        make.width.mas_equalTo(78);
    }];
    [self.detailMarriageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.marriageLabel.mas_right).offset(10);
        make.centerY.equalTo(self.marriageImage);
        make.right.equalTo(self).offset(12);
    }];
}
-(UIImageView *)nikeImage{
    if (!_nikeImage) {
        _nikeImage = [[UIImageView alloc]init];
        _nikeImage.image = [UIImage imageNamed:@"handinhand_nickname"];
    }
    return _nikeImage;
}

-(UILabel *)nikeNameLabel{
    if (!_nikeNameLabel) {
        _nikeNameLabel = [[UILabel alloc]init];
        _nikeNameLabel.text = @"昵称：";
        _nikeNameLabel.font = [UIFont systemFontOfSize:14];
        _nikeNameLabel.textAlignment = NSTextAlignmentLeft;
        _nikeNameLabel.textColor = DSColorFromHex(0x999999);
    }
    return _nikeNameLabel;
}
-(UILabel *)detailNikeNameLabel{
    if (!_detailNikeNameLabel) {
        _detailNikeNameLabel = [[UILabel alloc]init];
        _detailNikeNameLabel.text = @"猜猜我是谁";
        _detailNikeNameLabel.font = [UIFont systemFontOfSize:14];
        _detailNikeNameLabel.textAlignment = NSTextAlignmentLeft;
        _detailNikeNameLabel.textColor = DSColorFromHex(0x4D4D4D);
    }
    return _detailNikeNameLabel;
}
-(UIImageView *)sexImage{
    if (!_sexImage) {
        _sexImage = [[UIImageView alloc]init];
        _sexImage.image = [UIImage imageNamed:@"icon_gender"];
    }
    return _sexImage;
}
-(UILabel *)sexLabel{
    if (!_sexLabel) {
        _sexLabel = [[UILabel alloc]init];
        _sexLabel.text = @"性别：";
        _sexLabel.font = [UIFont systemFontOfSize:14];
        _sexLabel.textAlignment = NSTextAlignmentLeft;
        _sexLabel.textColor = DSColorFromHex(0x999999);
    }
    return _sexLabel;
}
-(UILabel *)detailSexLabel{
    if (!_detailSexLabel) {
        _detailSexLabel = [[UILabel alloc]init];
        _detailSexLabel.text = @"女";
        _detailSexLabel.font = [UIFont systemFontOfSize:14];
        _detailSexLabel.textAlignment = NSTextAlignmentLeft;
        _detailSexLabel.textColor = DSColorFromHex(0x4D4D4D);
    }
    return _detailSexLabel;
}
-(UIImageView *)birthdayImage{
    if (!_birthdayImage) {
        _birthdayImage = [[UIImageView alloc]init];
        _birthdayImage.image = [UIImage imageNamed:@"icon_age"];
    }
    return _birthdayImage;
}
-(UILabel *)birthdayLabel{
    if (!_birthdayLabel) {
        _birthdayLabel = [[UILabel alloc]init];
        _birthdayLabel.text = @"出生日期：";
        _birthdayLabel.font = [UIFont systemFontOfSize:14];
        _birthdayLabel.textAlignment = NSTextAlignmentLeft;
        _birthdayLabel.textColor = DSColorFromHex(0x999999);
    }
    return _birthdayLabel;
}
-(UILabel *)detailBirthdayLabel{
    if (!_detailBirthdayLabel) {
        _detailBirthdayLabel = [[UILabel alloc]init];
        _detailBirthdayLabel.text = @"19岁";
        _detailBirthdayLabel.font = [UIFont systemFontOfSize:14];
        _detailBirthdayLabel.textAlignment = NSTextAlignmentLeft;
        _detailBirthdayLabel.textColor = DSColorFromHex(0x4D4D4D);
    }
    return _detailBirthdayLabel;
}
-(UIImageView *)heightImage{
    if (!_heightImage) {
        _heightImage = [[UIImageView alloc]init];
        _heightImage.image = [UIImage imageNamed:@"icon_height"];
    }
    return _heightImage;
}
- (UILabel *)heightLabel{
    if (!_heightLabel) {
        _heightLabel = [[UILabel alloc]init];
        _heightLabel.text = @"身高：";
        _heightLabel.font = [UIFont systemFontOfSize:14];
        _heightLabel.textAlignment = NSTextAlignmentLeft;
        _heightLabel.textColor = DSColorFromHex(0x999999);
    }
    return _heightLabel;
}
-(UILabel *)detailHeightLabel{
    if (!_detailHeightLabel) {
        _detailHeightLabel = [[UILabel alloc]init];
        _detailHeightLabel.text = @"166cm";
        _detailHeightLabel.font = [UIFont systemFontOfSize:14];
        _detailHeightLabel.textAlignment = NSTextAlignmentLeft;
        _detailHeightLabel.textColor = DSColorFromHex(0x4D4D4D);
    }
    return _detailHeightLabel;
}
-(UIImageView *)incomeImage{
    if (!_incomeImage) {
        _incomeImage = [[UIImageView alloc]init];
        _incomeImage.image = [UIImage imageNamed:@"icon_income"];
    }
    return _incomeImage;
}
-(UILabel *)incomeLabel{
    if (!_incomeLabel) {
        _incomeLabel = [[UILabel alloc]init];
        _incomeLabel.text = @"月收入：";
        _incomeLabel.font = [UIFont systemFontOfSize:14];
        _incomeLabel.textAlignment = NSTextAlignmentLeft;
        _incomeLabel.textColor = DSColorFromHex(0x999999);
    }
    return _incomeLabel;
}
-(UILabel *)detailIncomeLabel{
    if (!_detailIncomeLabel) {
        _detailIncomeLabel = [[UILabel alloc]init];
        _detailIncomeLabel.text = @"5000元/月";
        _detailIncomeLabel.font = [UIFont systemFontOfSize:14];
        _detailIncomeLabel.textAlignment = NSTextAlignmentLeft;
        _detailIncomeLabel.textColor = DSColorFromHex(0x4D4D4D);
    }
    return _detailIncomeLabel;
}
-(UIImageView *)addressImage{
    if (!_addressImage) {
        _addressImage = [[UIImageView alloc]init];
        _addressImage.image = [UIImage imageNamed:@"icon_place_of_residence"];
    }
    return _addressImage;
}
-(UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.text = @"居住地：";
        _addressLabel.font = [UIFont systemFontOfSize:14];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.textColor = DSColorFromHex(0x999999);
    }
    return _addressLabel;
}
-(UILabel *)detailAddressLabel{
    if (!_detailAddressLabel) {
        _detailAddressLabel = [[UILabel alloc]init];
        _detailAddressLabel.text = @"上海市 闵行区";
        _detailAddressLabel.font = [UIFont systemFontOfSize:14];
        _detailAddressLabel.textAlignment = NSTextAlignmentLeft;
        _detailAddressLabel.textColor = DSColorFromHex(0x4D4D4D);
    }
    return _detailAddressLabel;
}
-(UIImageView *)marriageImage{
    if (!_marriageImage) {
        _marriageImage = [[UIImageView alloc]init];
        _marriageImage.image = [UIImage imageNamed:@"icon_marital_status"];
    }
    return _marriageImage;
}
-(UILabel *)marriageLabel{
    if (!_marriageLabel) {
        _marriageLabel = [[UILabel alloc]init];
        _marriageLabel.text = @"婚姻状况：";
        _marriageLabel.font = [UIFont systemFontOfSize:14];
        _marriageLabel.textAlignment = NSTextAlignmentLeft;
        _marriageLabel.textColor = DSColorFromHex(0x999999);
    }
    return _marriageLabel;
}
-(UILabel *)detailMarriageLabel{
    if (!_detailMarriageLabel) {
        _detailMarriageLabel = [[UILabel alloc]init];
        _detailMarriageLabel.text = @"未婚";
        _detailMarriageLabel.font = [UIFont systemFontOfSize:14];
        _detailMarriageLabel.textAlignment = NSTextAlignmentLeft;
        _detailMarriageLabel.textColor = DSColorFromHex(0x4D4D4D);
    }
    return _detailMarriageLabel;
}
@end
