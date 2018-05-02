//
//  WantedJobTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WantedJobTableViewCell.h"

@implementation WantedJobTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCellWithData:(JobModel *)model{
//    if ([model isKindOfClass:[JobModel class]]) {
//        JobModel *jobModel = (JobModel *)model;
        self.btnJob.layer.masksToBounds = YES;
        self.btnJob.layer.cornerRadius = 3.f;
        self.titleLabel.text = model.title;
    self.btnSeeCount.hidden = YES;
        [self.btnSeeCount setTitle:[NSString stringWithFormat:@"%@",model.click_count] forState:UIControlStateNormal];
        self.wagesLabel.text = [NSString stringWithFormat:@"%@-%@元/月",model.min_wages,model.max_wages];
        self.addressLabel.text = model.address;
//    }else{
//        CollectModel *collModel = (CollectModel *)model;
//        self.btnJob.layer.masksToBounds = YES;
//        self.btnJob.layer.cornerRadius = 3.f;
//        self.titleLabel.text = collModel.title;
////        [self.btnSeeCount setTitle:[NSString stringWithFormat:@"%@",collModel.click_count] forState:UIControlStateNormal];
////        self.wagesLabel.text = [NSString stringWithFormat:@"%@-%@元/月",collModel.min_wages,collModel.max_wages];
////        self.addressLabel.text = collModel.address;
//    }
    
}

-(void)layoutSubviews
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xffffff);
    self.selectedBackgroundView = view;

    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *view in control.subviews)
            {
                if ([view isKindOfClass: [UIImageView class]]) {
                    UIImageView *image=(UIImageView *)view;
                    if (self.selected) {
                        image.image=[UIImage imageNamed:@"icon_circle_selected"];
                    }
                    else
                    {
                        image.image=[UIImage imageNamed:@"icon_circle_not_selected"];
                    }
                }
            }
        }
    }
    
    [super layoutSubviews];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
