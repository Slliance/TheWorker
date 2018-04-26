//
//  WithdrawRecordTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaleRecordModel.h"
@interface WithdrawRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelCardNO;
@property (weak, nonatomic) IBOutlet UILabel *labelMoney;
@property (weak, nonatomic) IBOutlet UILabel *labelState;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
-(void)initCellWithData:(SaleRecordModel *)model;
@end
