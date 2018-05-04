//
//  MylikeCollectionViewCell.m
//  TheWorker
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "MylikeCollectionViewCell.h"

@implementation MylikeCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setContentLayout];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}


-(void)setContentLayout{
    [self addSubview: self.headImgae];
    [self addSubview:self.headBtn];
    [self addSubview:self.nameLabel];
    [self addSubview:self.yearLabel];
    [self.headImgae mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(70);
        
    }];
    [self.headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImgae).offset(5);
        make.left.equalTo(self.headImgae).offset(54);
        make.height.width.mas_equalTo(22);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImgae.mas_bottom).offset(10);
        make.centerX.equalTo(self.headImgae);
        make.width.mas_equalTo(100);
    }];
    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(6);
        make.centerX.equalTo(self.headImgae);
        make.width.mas_equalTo(100);
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
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = @"猜我猜不猜谁";
    }
    return _nameLabel;
}
-(UILabel *)yearLabel{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc]init];
        _yearLabel.font = [UIFont systemFontOfSize:12];
        _yearLabel.textColor = DSColorFromHex(0x4D4D4D);
        _yearLabel.textAlignment = NSTextAlignmentCenter;
        _yearLabel.text = @"18岁";
    }
    return _yearLabel;
}
@end
