//
//  MyRentDetailOrderInfoTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/13.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RentOrderModel.h"
@interface MyRentDetailOrderInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelState;
@property (weak, nonatomic) IBOutlet UILabel *labelReason;
@property (nonatomic, retain) RentOrderModel *rentOrderModel;
-(void)initCellWith:(RentOrderModel *)model;
+(CGFloat)getCellHeightWithData:(RentOrderModel *)model;
@property (nonatomic, copy) void(^photoBlock)(RentOrderModel *,NSInteger);

@end
