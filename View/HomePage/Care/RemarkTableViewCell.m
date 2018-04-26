//
//  RemarkTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/22.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RemarkTableViewCell.h"

@implementation RemarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCellWithData:(GoodsRemarkModel *)model{
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseUrl,model.headimg]] placeholderImage:[UIImage imageNamed:placeholderImage_user_headimg]];
    self.timeLabel.text = model.createtime;
    self.labelName.text = model.nickname;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 15.f;
    int count = [model.score intValue];
    for (int i = 0; i < count; i ++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"icon_shop_review"];
        imageView.frame = CGRectMake(i*12+4*i, 4, 12, 12);
        [self.starView addSubview:imageView];
    }
    self.labelRemarkLong.text = model.content;

    CGSize size = [model.content sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth - 20, 3000)];
    self.labelRemarkLong.frame = CGRectMake(10, 95, size.width, size.height);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)getCellHeight:(GoodsRemarkModel *)model{
    if ([model.content isEqualToString:@""]) {
        return 95.f;
    }
    CGSize size = [model.content sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth - 20, 3000)];

    return 95 + size.height + 10;
}

@end
