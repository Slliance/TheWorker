//
//  RemarkTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/22.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsRemarkModel.h"
@interface RemarkTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelRemarkShort;
@property (weak, nonatomic) IBOutlet UILabel *labelRemarkLong;
@property (weak, nonatomic) IBOutlet UILabel *labelName;

-(void)initCellWithData:(GoodsRemarkModel *)model;

+(CGFloat)getCellHeight:(GoodsRemarkModel *)model;
@end
