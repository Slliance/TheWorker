//
//  GoodsInfoTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/16.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
@interface GoodsInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UILabel *labelConverted;
@property (weak, nonatomic) IBOutlet UILabel *labelConvertAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelConvertTime;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsName;

-(void)initCellWithData:(GoodsModel *)model;
@end
