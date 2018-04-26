//
//  BrandTableViewCell.h
//  TheWorker
//
//  Created by yanghao on 8/19/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartnerModel.h"
@interface BrandTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelCompanyName;
-(void)initCellWithData:(PartnerModel *)model;
@end
