//
//  ChooseGoodsDetailInfoTableViewCell.h
//  TheWorker
//
//  Created by yanghao on 9/27/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
@interface ChooseGoodsDetailInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;


-(void)initCellWithData:(NSString *)str;

@end
