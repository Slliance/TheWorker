//
//  MyJobTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/28.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyJobTableViewCell.h"

@implementation MyJobTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCellWithData:(MyApplicationModel *)model{
    self.labelTime.text = model.create_time;
    self.labelCompany.text = model.company;
    self.labelJobName.text = model.job_name;
    switch ([model.status integerValue]) {
        case 1:
            self.labelState.text = @"审核中";
            self.labelState.textColor = [UIColor colorWithHexString:@"ff6666"];
            break;
        case 2:
            self.labelState.text = @"面试中";
            self.labelState.textColor = [UIColor colorWithHexString:@"ff6666"];
            break;
        case 3:
            self.labelState.text = @"未通过";
            self.labelState.textColor = [UIColor colorWithHexString:@"ff6666"];
             break;
        case 4:
            self.labelState.text = @"体检中";
            self.labelState.textColor = [UIColor colorWithHexString:@"ff6666"];
            break;
        case 5:
            self.labelState.text = @"已入职";
            self.labelState.textColor = [UIColor colorWithHexString:@"999999"];
            break;
        default:
            break;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
