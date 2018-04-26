//
//  SaleRecordTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaleRecordModel.h"
@interface SaleRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelState;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelRemainAmount;
@property (weak, nonatomic) IBOutlet UILabel *labelAmount;

-(void)initCellWithData:(SaleRecordModel *)model;
@end
