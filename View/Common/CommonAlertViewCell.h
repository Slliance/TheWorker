//
//  CommonAlertViewCell.h
//  TheWorker
//
//  Created by apple on 2018/5/19.
//  Copyright © 2018年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"
@interface CommonAlertViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *bgImage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *typeLabel;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)CouponModel *model;

@end
