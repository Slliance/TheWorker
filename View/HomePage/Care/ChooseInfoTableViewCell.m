//
//  ChooseInfoTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/21.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ChooseInfoTableViewCell.h"

@implementation ChooseInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)initCellWithData:(NSString *)str{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.selected == YES) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"6398f1"];
        self.choosedImage.hidden = NO;
    }else{
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.choosedImage.hidden = YES;
    }

    // Configure the view for the selected state
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    //    self.contentView.backgroundColor = [UIColor whiteColor];
}

@end
