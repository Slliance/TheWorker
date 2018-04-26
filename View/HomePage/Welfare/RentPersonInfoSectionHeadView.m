//
//  RentPersonInfoSectionHeadView.m
//  TheWorker
//
//  Created by yanghao on 8/21/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "RentPersonInfoSectionHeadView.h"

@implementation RentPersonInfoSectionHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)initViewWithSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            [self.showBtn setImage:[UIImage imageNamed:@"icon_service_items"] forState:UIControlStateNormal];
            [self.showBtn setTitle:@"服务项目" forState:UIControlStateNormal];

        }
            break;
        case 1:
        {
            [self.showBtn setImage:[UIImage imageNamed:@"icon_personal_label"] forState:UIControlStateNormal];
            [self.showBtn setTitle:@"个人标签" forState:UIControlStateNormal];

        }
            break;
        case 2:
        {
            [self.showBtn setImage:[UIImage imageNamed:@"icon_basic_information"] forState:UIControlStateNormal];
            [self.showBtn setTitle:@"基本信息" forState:UIControlStateNormal];

        }
            break;
            
        default:
            break;
    }
    [self.showBtn setImagePositionWithType:SSImagePositionTypeLeft spacing:5.f];

}
@end
