//
//  MyIntegralTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/24.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntegralModel.h"
@interface MyIntegralTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelType;
@property (weak, nonatomic) IBOutlet UILabel *labelMoney;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelScore;

-(void)initCellWithData:(IntegralModel *)model;
@end
