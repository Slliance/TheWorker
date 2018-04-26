//
//  OrderDetailTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreGoodsModel.h"
@interface OrderDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *propertyOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (nonatomic, retain) StoreGoodsModel *model;

@property (nonatomic, copy) void(^buyAgainBlock)(StoreGoodsModel *);
@property (nonatomic, copy) void(^applySaleServiceBlock)(StoreGoodsModel *);
@property (nonatomic, copy) void(^commentOrderBlock)(StoreGoodsModel *);



-(void)initCellWithData:(StoreGoodsModel *)model status:(NSInteger)status;
@end
