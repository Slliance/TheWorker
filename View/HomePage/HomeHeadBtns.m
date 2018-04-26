//
//  HomeHeadBtns.m
//  TheWorker
//
//  Created by apple on 2018/4/24.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "HomeHeadBtns.h"

@implementation HomeHeadBtns

-(instancetype)init{
    if (self = [super init]) {
        [self setCortentLayout];
    }
    return self;
}
-(void)setCortentLayout{
    [self addSubview:self.headImage];
    [self addSubview:self.contentLabel];
    [self addSubview:self.headBtn];
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(9);
        make.left.equalTo(self).offset(ScreenWidth/6-31);
        make.width.mas_equalTo(54);
        make.height.mas_equalTo(49);
        
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImage.mas_bottom).offset(5);
        make.centerX.equalTo(self.headImage);
        make.width.mas_equalTo(ScreenWidth/3-8);
        make.height.mas_equalTo(12);
    }];
    [self.headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}
-(UIButton *)headBtn{
    if (!_headBtn) {
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headBtn.backgroundColor = [UIColor clearColor];
    }
    return _headBtn;
}
-(UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc]init];
        _headImage.userInteractionEnabled = YES;
    }
    return _headImage;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = [UIColor blackColor];
    }
    return _contentLabel;
}
@end
