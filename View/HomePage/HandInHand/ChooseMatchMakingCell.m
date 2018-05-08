//
//  ChooseMatchMakingCell.m
//  TheWorker
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "ChooseMatchMakingCell.h"

@implementation ChooseMatchMakingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setContentLayout];
        self.backgroundColor = DSColorFromHex(0xEEEEEE);
    }
    
    return self;
}


-(void)setContentLayout{
    [self addSubview:self.bgView];
    [self.bgView addSubview: self.headImgae];
    [self.bgView addSubview:self.headBtn];
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.yearLabel];
    [self.bgView addSubview:self.contentLabel];
    [self.bgView addSubview:self.distenceLabel];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self).offset(-5);
    }];
    [self.headImgae mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(10);
        make.left.equalTo(self.bgView).offset(12);
        make.width.height.mas_equalTo(70);
        
    }];
    [self.headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImgae).offset(5);
        make.left.equalTo(self.headImgae).offset(54);
        make.height.width.mas_equalTo(22);
    }];
    [self.distenceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(16);
        make.right.equalTo(self.bgView).offset(-12);
        make.width.mas_equalTo(70);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImgae.mas_bottom).offset(10);
        make.left.equalTo(self.headImgae.mas_bottom).offset(27);
        make.right.equalTo(self.distenceLabel.mas_right).offset(-5);
    }];
    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.left.equalTo(self.headImgae.mas_right).offset(27);
        make.right.equalTo(self.bgView).offset(-12);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yearLabel.mas_bottom).offset(10);
        make.left.equalTo(self.headImgae.mas_right).offset(27);
        make.right.equalTo(self.bgView).offset(-12);
    }];
}
-(UIImageView *)headImgae{
    if (!_headImgae) {
        _headImgae = [[UIImageView alloc]init];
        _headImgae.image = [UIImage imageNamed:@"avatar_defaul"];
        [_headImgae.layer setMasksToBounds:YES];
        [_headImgae.layer setCornerRadius:35];
    }
    return _headImgae;
}
-(UIButton *)headBtn{
    if (!_headBtn) {
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headBtn setImage:[UIImage imageNamed:@"icon_female"] forState:UIControlStateNormal
         ] ;
        _headBtn.backgroundColor = DSColorFromHex(0xF9E3EC);
        [_headBtn.layer setMasksToBounds:YES];
        [_headBtn.layer setCornerRadius:11];
    }
    return _headBtn;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = DSColorFromHex(0x4D4D4D);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.text = @"猜我猜不猜谁";
    }
    return _nameLabel;
}
-(UILabel *)yearLabel{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc]init];
        _yearLabel.font = [UIFont systemFontOfSize:12];
        _yearLabel.textColor = DSColorFromHex(0x4D4D4D);
        _yearLabel.textAlignment = NSTextAlignmentLeft;
        _yearLabel.text = @"18岁";
    }
    return _yearLabel;
}
-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = DSColorFromHex(0x4D4D4D);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.text = @"“xdfshklsldaksldml;ld;asl;dsl;d;lds”";
    }
   
    return _contentLabel;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
-(UILabel *)distenceLabel{
    if (!_distenceLabel) {
        _distenceLabel = [[UILabel alloc]init];
        _distenceLabel.font = [UIFont systemFontOfSize:12];
        _distenceLabel.textColor = DSColorFromHex(0x1C6AF2);
        _distenceLabel.textAlignment = NSTextAlignmentRight;
        _distenceLabel.text = @"距离300m";
    }
    return _distenceLabel;
}
@end
