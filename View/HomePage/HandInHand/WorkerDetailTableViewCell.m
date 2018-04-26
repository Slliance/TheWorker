//
//  WorkerDetailTableViewCell.m
//  TheWorker
//
//  Created by yanghao on 8/29/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "WorkerDetailTableViewCell.h"

@implementation WorkerDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 4.f;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initView:(NSString *)content{
    
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ScreenWidth - 40, 3000)];
    
    CGRect rect = self.labelContent.frame;
    rect.size = size;
    self.labelContent.frame = rect;
    self.labelContent.text = content;
    self.labelContent.textColor = [UIColor colorWithHexString:@"666666"];
}

+(CGFloat)getCellHeight:(NSString *)content{
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(ScreenWidth - 40, 3000)];

    return size.height + 40;
}
@end
