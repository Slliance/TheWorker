//
//  MyRentDetailOrderStateTableViewCell.h
//  TheWorker
//
//  Created by yanghao on 9/2/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RentOrderModel.h"
@interface MyRentDetailOrderStateTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *disagreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateTitleLabel;

-(void)initCellWith:(RentOrderModel *)model;
+(CGFloat)getCellHeightWith:(RentOrderModel *)model;
@end
