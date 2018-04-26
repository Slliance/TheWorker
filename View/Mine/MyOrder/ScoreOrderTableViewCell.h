//
//  ScoreOrderTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreOrderModel.h"
@interface ScoreOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsState;
-(void)initCellWithData:(ScoreOrderModel *)model;
@end
