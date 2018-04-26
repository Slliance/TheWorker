//
//  WaresCollectionViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/17.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreGoodsModel.h"
@interface WaresCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *waresImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelWareName;
@property (weak, nonatomic) IBOutlet UILabel *labelSales;
@property (weak, nonatomic) IBOutlet UILabel *labelPrices;
-(void)initCellWithData:(StoreGoodsModel *)model;
@end
