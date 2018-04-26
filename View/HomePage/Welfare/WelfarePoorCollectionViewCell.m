//
//  WelfarePoorCollectionViewCell.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/15.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WelfarePoorCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation WelfarePoorCollectionViewCell
-(void)initCellWithData:(GoodsModel *)model{
    self.imgBgView.layer.borderColor = [UIColor colorWithHexString:@"f0f0f0"].CGColor;
    self.imgBgView.layer.borderWidth = 1;
    self.labelGoodsName.text = model.name;
    [self.goodsImgView setImageWithString:model.show_img placeHoldImageName:placeholderImage_home_banner];
    self.labelPrice.text = [NSString stringWithFormat:@"%@积分",model.point];
    self.goodsConverted.text = [NSString stringWithFormat:@"%@人已领取",model.exchanged_count];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
