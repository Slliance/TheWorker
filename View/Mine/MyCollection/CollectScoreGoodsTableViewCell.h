//
//  CollectScoreGoodsTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/30.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectModel.h"
@interface CollectScoreGoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
-(void)initCellWithData:(CollectModel *)model;
@end
