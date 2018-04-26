//
//  WelfareActiveCollectionViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/15.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WelfareActiveCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation WelfareActiveCollectionViewCell

-(void)initCellWith:(GoodsModel *)model{
    self.imgBgView.layer.borderColor = [UIColor colorWithHexString:@"f0f0f0"].CGColor;
    self.imgBgView.layer.borderWidth = 1;
    [self.goodsImageView setImageWithString:model.show_img placeHoldImageName:@"bg_no_pictures"];
//    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.show_img]];
    self.labelGoodsName.text = model.name;
    self.labelPrice.text = [NSString stringWithFormat:@"%@积分",model.point];
//    self.labelPrice.text = [NSString stringWithFormat:@"%@聚友值 %@积分",model.friend_amount,model.point];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
