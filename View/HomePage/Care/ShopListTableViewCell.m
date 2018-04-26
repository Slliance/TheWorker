//
//  ShopListTableViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/17.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ShopListTableViewCell.h"

@implementation ShopListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)initCellWithData:(StoreModel *)model{
    [self.shopImg.layer setBorderColor:[UIColor colorWithHexString:@"f0f0f0"].CGColor];
    [self.shopImg.layer setBorderWidth:1];
    self.labelShopName.text = model.name;
    [self.shopImg setImageWithString:model.logo placeHoldImageName:@"bg_no_pictures"];
//    [self.shopImg setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
    self.labelContent.text = model.describ;
    CGFloat count = [model.score floatValue];
    for (int i = 0; i < count; i++) {
        CGRect rect = self.starView.frame;
        UIImage *image = [UIImage imageNamed:@"icon_shop_review"];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        CGFloat width = 12;
        CGFloat margin = 8;
        CGFloat height = rect.size.height;
        CGFloat starX = i*width+i*margin;
        imageView.frame = CGRectMake(starX, 0, width, height);
        [self.starView addSubview:imageView];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
