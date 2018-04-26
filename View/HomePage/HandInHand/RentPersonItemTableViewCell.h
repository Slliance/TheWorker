//
//  RentPersonItemTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkillModel.h"
@interface RentPersonItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgSelected;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

-(void)initCellWithData:(BOOL)isSelect model:(SkillModel *)model;
@end
