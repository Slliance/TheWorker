//
//  DeclarationOfLoveView.m
//  TheWorker
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "DeclarationOfLoveView.h"

@implementation DeclarationOfLoveView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setContentLayout];
    }
    return self;
}

-(void)setContentLayout{
    [self addSubview:self.loveLabel];
    [self addSubview:self.loveContentLabel];
    [self addSubview:self.allBtn];
    [self.loveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(13);
        make.top.equalTo(self).offset(18);
        make.right.equalTo(self).offset(12);
    }];
    [self.loveContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(13);
        make.top.equalTo(self.loveLabel.mas_bottom).offset(9);
        make.right.equalTo(self).offset(12);
    }];
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-6);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(7);
    }];
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
        _loveContentLabel.numberOfLines = 2;
        _loveContentLabel.text = @"sdfghjkl;'fghjklcvbnm,xcvbnm,.sdfghjlcdasdfghjkertyu";
    }
    return _loveContentLabel;
}
-(UIButton *)allBtn{
    if (!_allBtn) {
        _allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allBtn setImage:[UIImage imageNamed:@"icon_double_arrow_down"] forState:UIControlStateNormal];
        [_allBtn setImage:[UIImage imageNamed:@"icon_double_arrow_up"] forState:UIControlStateSelected];
    }
    return _allBtn;
}
@end
