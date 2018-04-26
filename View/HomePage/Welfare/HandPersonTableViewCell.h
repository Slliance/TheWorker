//
//  HandPersonTableViewCell.h
//  TheWorker
//
//  Created by yanghao on 8/23/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HandInModel.h"
@interface HandPersonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewSex;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

-(void)initCell:(HandInModel *)model;
@end
