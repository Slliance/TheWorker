//
//  OrderTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/22.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreGoodsModel.h"
@interface OrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *propertyOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

-(void)initViewWithData:(NSArray *)array;
-(void)initViewWith:(StoreGoodsModel *)model;
+(CGFloat)getCellHeightWithModel:(StoreGoodsModel *)model;
+(CGFloat)getCellHeightWithArray:(NSArray *)array;
@end
