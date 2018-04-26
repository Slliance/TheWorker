//
//  PoorListCollectionViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/15.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
@interface PoorListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *imgBgView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelConverted;
-(void)initCellWith:(GoodsModel *)model;
@end
