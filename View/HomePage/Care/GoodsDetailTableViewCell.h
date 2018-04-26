//
//  GoodsDetailTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/21.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreGoodsModel.h"
@interface GoodsDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelPriceDelete;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UILabel *labelConverted;
-(void)initCellWithData:(StoreGoodsModel *)model;
@end
