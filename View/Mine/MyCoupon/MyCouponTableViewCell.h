//
//  MyCouponTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/28.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"
@interface MyCouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *btnGet;
@property (weak, nonatomic) IBOutlet UILabel *labelMoney;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property (nonatomic, copy) void(^getBlock)(void);

-(void)initCellWithDataType:(CouponModel *)model;
@end
