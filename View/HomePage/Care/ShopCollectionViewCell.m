//
//  ShopCollectionViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/17.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ShopCollectionViewCell.h"

@implementation ShopCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCellWithData:(StoreModel *)model{
    
    self.labelShopName.text = model.name;
    [self.shopImageView setImageWithString:model.logo placeHoldImageName:@"bg_no_pictures"];
//    [self.shopImageView setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"bg_no_pictures"]];
    CGFloat count = [model.score floatValue];
    for (int i = 0; i < count; i++) {
        CGRect rect = self.starView.frame;
        UIImage *image = [UIImage imageNamed:@"icon_shop_review"];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        CGFloat width = 12;
        CGFloat margin =  ((ScreenWidth-100) / 3 - 60)/4;
        CGFloat height = rect.size.height;
        CGFloat starX = i*width+(i*margin)+(((ScreenWidth-100) / 3 - ((count-1)*margin+count*width))/2);
        imageView.frame = CGRectMake(starX, 0, width, height);
        [self.starView addSubview:imageView];
    }
}

@end
