//
//  RentPersonFansTableViewCell.h
//  TheWorker
//
//  Created by yanghao on 8/23/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FansModel.h"
@interface RentPersonFansTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
-(void)initCellWith:(FansModel *)model;
@end
