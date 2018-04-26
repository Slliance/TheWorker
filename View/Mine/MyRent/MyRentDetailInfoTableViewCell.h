//
//  MyRentDetailInfoTableViewCell.h
//  TheWorker
//
//  Created by yanghao on 9/2/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RentOrderModel.h"
@interface MyRentDetailInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentLongLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;

@property (weak, nonatomic) IBOutlet UIButton *btnlocation;
@property (weak, nonatomic) IBOutlet UILabel *msgTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentLonglabel;
@property (nonatomic, copy) void(^skipToMapBlock)(void);
-(void)initCellWith:(RentOrderModel *)model;
+(CGFloat)getHeightWithModel:(RentOrderModel *)model;
@end
