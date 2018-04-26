//
//  OrderDetailTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreGoodsModel.h"
@interface OrderDetailFinishTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *propertyOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UIView *bottomView;

-(void)initCellWithData:(StoreGoodsModel *)model;
@end
