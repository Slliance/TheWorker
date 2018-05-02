//
//  DetailMatchMakingHeadView.m
//  TheWorker
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "DetailMatchMakingHeadView.h"

@implementation DetailMatchMakingHeadView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setContentLayout];
    }
    return self;
}


-(void)setContentLayout{
    [self addSubview:self.headImage];
    [self addSubview:self.sexImage];
    [self addSubview:self.nameLabel];
    [self addSubview:self.distanceLabel];
    [self addSubview:self.yearLabel];
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self).offset(20);
        make.width.height.mas_equalTo(100);
    }];
    [self.sexImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(48);
        make.left.equalTo(self.headImage.mas_right).offset(20);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(15);
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexImage);
        make.right.equalTo(self).offset(-15);
        make.width.mas_equalTo(60);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(48);
        make.left.equalTo(self.sexImage.mas_right).offset(10);
        make.right.equalTo(self.distanceLabel.mas_left).offset(-10);
    }];
    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sexImage.mas_right).offset(10);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(20);
    }];
}

-(UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc]init];
        [_headImage.layer setCornerRadius:50];
        [_headImage.layer setMasksToBounds:YES];
        _headImage.image = [UIImage imageNamed:@"avatar_defaul"];
    }
    return _headImage;
}
-(UIImageView *)sexImage{
    if (!_sexImage) {
        _sexImage = [[UIImageView alloc]init];
        _sexImage.image = [UIImage imageNamed:@"icon_female"];
    }
    return _sexImage;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor =DSColorFromHex(0x4D4D4D);
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"猜猜我是谁";
    }
    return _nameLabel;
}
-(UILabel *)yearLabel{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc]init];
        _yearLabel.textColor =DSColorFromHex(0x4D4D4D);
        _yearLabel.font = [UIFont systemFontOfSize:12];
        _yearLabel.textAlignment = NSTextAlignmentLeft;
        _yearLabel.text = @"19岁  166cm  月收入5000元";
    }
    return _yearLabel;
}
-(UILabel *)distanceLabel{
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc]init];
        _distanceLabel.textColor =DSColorFromHex(0x1C6AF2);
        _distanceLabel.font = [UIFont systemFontOfSize:12];
        _distanceLabel.textAlignment = NSTextAlignmentLeft;
        _distanceLabel.text = @"距离900m";
    }
    return _distanceLabel;
}
@end
