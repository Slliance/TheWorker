//
//  CommonChooseBtn.m
//  TheWorker
//
//  Created by apple on 2018/4/27.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "CommonChooseBtn.h"

@implementation CommonChooseBtn

-(instancetype)init{
    if (self = [super init]) {
        [self setContentLayout];
    }
    return self;
}
-(void)setContentLayout{
    self.layer.masksToBounds = YES;
    [self.layer setMasksToBounds:YES];
    self.userInteractionEnabled = YES;
    [self.layer setBorderColor:DSColorFromHex(0x999999).CGColor];
    [self.layer setBorderWidth:1];
    [self addSubview:self.titleLabel];
    [self addSubview:self.inputImage];
    [self addSubview:self.selectedBtn];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).offset(-24);
    }];
    [self.inputImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-11);
        make.bottom.equalTo(self).offset(-17);
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(7);
    }];
    [self.selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = DSColorFromHex(0x999999);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.userInteractionEnabled = YES;
    }
    return _titleLabel;
}
-(UIImageView *)inputImage{
    if (!_inputImage) {
        _inputImage = [[UIImageView alloc]init];
        _inputImage.userInteractionEnabled = YES;
        _inputImage.image = [UIImage imageNamed:@"holdinghands_arrow_down"];
    }
    return _inputImage;
}
-(UIButton *)selectedBtn{
    if (!_selectedBtn) {
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _selectedBtn;
}
@end
