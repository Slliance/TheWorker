//
//  NavgationView.m
//  TheWorker
//
//  Created by apple on 2018/4/26.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "NavgationView.h"

@implementation NavgationView

-(instancetype)init{
    if (self = [super init]) {
        [self setContentLayout];
    }
    return self;
}
-(void)setContentLayout{
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(64);
    }];
}
-(UIImageView *)bgView{
    if (!_bgView) {
        _bgView = [[UIImageView alloc]init];
        _bgView.image = [UIImage imageNamed:@"顶部渐变色"];
    }
    return _bgView;
}
@end
