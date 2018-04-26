//
//  RentSelfTableViewCell.h
//  TheWorker
//
//  Created by yanghao on 8/21/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RentModel.h"
@interface RentSelfTableViewCell : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imgView;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *markScrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *headImgView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelName;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelPrice;

-(void)initCellWithModel:(RentModel *)model;

@end
