//
//  ClassifyLeftTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/22.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ClassifyLeftTableViewCell.h"

@implementation ClassifyLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCellWithData:(NSDictionary *)dic{
    self.labelGoodsName.text = dic[@"name"];
    [self.cellBgView.layer setBorderColor:[UIColor colorWithHexString:@"e9e9e9"].CGColor];
    [self.cellBgView.layer setBorderWidth:1];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.selected == YES) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.labelGoodsName.textColor = [UIColor colorWithHexString:@"6398f1"];
        self.labelLine.hidden = NO;
    }else{
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        self.labelGoodsName.textColor = [UIColor colorWithHexString:@"333333"];
        self.labelLine.hidden = YES;
    }
//     self.contentView.backgroundColor = [UIColor whiteColor];
    // Configure the view for the selected state
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
//    self.contentView.backgroundColor = [UIColor whiteColor];
}

@end
