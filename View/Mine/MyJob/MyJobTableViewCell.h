//
//  MyJobTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/28.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyApplicationModel.h"
@interface MyJobTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelJobName;
@property (weak, nonatomic) IBOutlet UILabel *labelCompany;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelState;
-(void)initCellWithData:(MyApplicationModel *)model;
@end
