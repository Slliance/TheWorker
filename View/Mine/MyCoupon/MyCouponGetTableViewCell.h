//
//  MyCouponGetTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/8.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"
@interface MyCouponGetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnGet;

@property (weak, nonatomic) IBOutlet UILabel *labelMoney;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;

-(void)initCellWithDataType:(CouponModel *)model;
@end
