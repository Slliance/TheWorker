//
//  PoorListCollectionViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/15.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "PoorListCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation PoorListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)initCellWith:(GoodsModel *)model{
    self.imgBgView.layer.borderColor = [UIColor colorWithHexString:@"f0f0f0"].CGColor;
    self.imgBgView.layer.borderWidth = 1.f;
//    CGFloat w = (ScreenWidth-75)/2;
//    self.imgBgView.frame = CGRectMake(0, 10, w-1, w);
//    self.goodsImageView.frame = CGRectMake(15, 15, w-30, w-30);
//    CGRect rect = self.imgBgView.frame;
//    self.labelGoodsName.frame = CGRectMake(0,rect.origin.y + rect.size.height + 10, w, 20);
//    CGRect rectPrice = self.labelPrice.frame;
//    rectPrice.origin.x = 0;
//    rectPrice.size.width = w/2;
//    self.labelPrice.frame = rectPrice;
//    self.labelConverted.frame = CGRectMake(rect.size.width/2, rect.origin.y + rect.size.height + 30, rect.size.width/2, 20);
    [self.goodsImageView setImageWithString:model.show_img placeHoldImageName:@"bg_no_pictures"];
//    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.show_img]];
    self.labelGoodsName.text = model.name;
    self.labelPrice.text = [NSString stringWithFormat:@"%@积分",model.point];
    self.labelConverted.text = [NSString stringWithFormat:@"%@人已兑换",model.exchanged_count];
}
@end
