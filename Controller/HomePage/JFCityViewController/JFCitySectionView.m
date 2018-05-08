//
//  JFCitySectionView.m
//  TheWorker
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "JFCitySectionView.h"

@implementation JFCitySectionView

-(instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.titleLabel];
        self.backgroundColor = [UIColor whiteColor];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-12);
        }];
    }
    return self;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = DSColorFromHex(0x999999);
    }
    return _titleLabel;
}
@end
