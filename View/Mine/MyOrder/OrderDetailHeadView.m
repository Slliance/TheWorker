//
//  OrderDetailHeadView.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "OrderDetailHeadView.h"

@implementation OrderDetailHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)initView:(OrderGoodsModel *)model{
    self.labelName.text = model.name;
    self.labelTel.text = model.mobile;
    self.labelAddress.text = model.address;
}
@end
