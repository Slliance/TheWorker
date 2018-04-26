//
//  MyRentPersonTableViewCell.h
//  TheWorker
//
//  Created by yanghao on 9/2/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RentOrderModel.h"
@interface MyRentPersonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewSex;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelTag;
-(void)initCellWith:(RentOrderModel *)model;


@end
