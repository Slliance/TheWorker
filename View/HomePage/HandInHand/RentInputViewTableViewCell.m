//
//  RentInputViewTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RentInputViewTableViewCell.h"

@implementation RentInputViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCellWithData:(NSString *)confirmed{
    if (confirmed) {
        self.messageTextView.text = confirmed   ;
        self.messageTextView.textColor = [UIColor colorWithHexString:@"666666"];
    }else{
        self.messageTextView.text = @" ";
        self.messageTextView.textColor = [UIColor colorWithHexString:@"666666"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
