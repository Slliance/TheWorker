//
//  WantedJobTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobModel.h"
@interface WantedJobTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *wagesLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnSeeCount;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnJob;
-(void)initCellWithData:(JobModel *)model;
@end
