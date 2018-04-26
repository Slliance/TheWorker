//
//  ShopCollectionViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/17.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreModel.h"
@interface ShopCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelShopName;
@property (weak, nonatomic) IBOutlet UIView *starView;
-(void)initCellWithData:(StoreModel *)model;
@end
