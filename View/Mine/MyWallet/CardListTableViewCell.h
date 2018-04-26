//
//  CardListTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletModel.h"
@interface CardListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelCardName;
@property (weak, nonatomic) IBOutlet UILabel *labelCardNum;
@property (weak, nonatomic) IBOutlet UIButton *btnCircle;


-(void)initCellWithData:(WalletModel *)model;
@end
