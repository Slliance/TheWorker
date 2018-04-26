//
//  ActiveListCollectionViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/15.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ActiveListCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation ActiveListCollectionViewCell

-(void)initCellWith:(GoodsModel *)model{
    self.imgBgView.layer.borderColor = [UIColor colorWithHexString:@"f0f0f0"].CGColor;
    self.imgBgView.layer.borderWidth = 1;
    [self.goodsImageView setImageWithString:model.show_img placeHoldImageName:placeholderImage_home_banner];
//    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.show_img]];
//    self.labelPrice.text = [NSString stringWithFormat:@"%@聚友值 %@积分",model.friend_amount,model.point];
    self.labelPrice.text = [NSString stringWithFormat:@"%@积分",model.point];
    self.labelName.text = model.name;
    self.labelCount.text = [NSString stringWithFormat:@"%@人已兑换",model.exchanged_count];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
