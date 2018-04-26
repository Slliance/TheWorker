//
//  OrderNumberTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderGoodsModel.h"
#import "GoodsModel.h"
@interface OrderNumberTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelState;
@property (weak, nonatomic) IBOutlet UILabel *labelNo;
-(void)initCellWithData:(OrderGoodsModel *)model;
@end
