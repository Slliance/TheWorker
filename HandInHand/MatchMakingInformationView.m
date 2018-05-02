//
//  MatchMakingInformationView.m
//  TheWorker
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "MatchMakingInformationView.h"

@implementation MatchMakingInformationView

-(instancetype)init{
    if (self = [super init]) {
        [self setContentLayout];
    }
    return self;
}

-(void)setContentLayout{
    [self addSubview:self.sexImage];
    [self addSubview:self.nameLabel];
    [self addSubview:self.yearLabel];
    [self addSubview:self.distanceLabel];
    [self addSubview:self.loveLabel];
    [self addSubview:self.loveContentLabel];
    [self addSubview:self.inputBtn];
    [self.sexImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(15);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(15);
        
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexImage);
        make.right.equalTo(self).offset(-15);
        make.width.mas_equalTo(60);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self.sexImage.mas_right).offset(10);
        make.right.equalTo(self.distanceLabel.mas_left).offset(-10);
    }];
    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.sexImage.mas_bottom).offset(18);
    }];
    [self.loveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.yearLabel.mas_bottom).offset(30);
    }];
    [self.loveContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.loveLabel.mas_bottom).offset(11);
    }];
    [self.inputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
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

-(UILabel *)loveLabel{
    if (!_loveLabel) {
        _loveLabel = [[UILabel alloc]init];
        _loveLabel.textColor =DSColorFromHex(0x999999);
        _loveLabel.font = [UIFont systemFontOfSize:12];
        _loveLabel.textAlignment = NSTextAlignmentLeft;
        _loveLabel.text = @"爱情宣言";
    }
    return _loveLabel;
}
-(UILabel *)loveContentLabel{
    if (!_loveContentLabel) {
        _loveContentLabel = [[UILabel alloc]init];
        _loveContentLabel.textColor =DSColorFromHex(0x4D4D4D);
        _loveContentLabel.font = [UIFont systemFontOfSize:12];
        _loveContentLabel.textAlignment = NSTextAlignmentLeft;
        _loveContentLabel.numberOfLines = 5;
        _loveContentLabel.text = @"sdfghjkl;'fghjklcvbnm,xcvbnm,.sdfghjlcdasdfghjkertyu";
    }
    return _loveContentLabel;
}

-(UIButton *)inputBtn{
    if (!_inputBtn) {
        _inputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _inputBtn;
}
@end
