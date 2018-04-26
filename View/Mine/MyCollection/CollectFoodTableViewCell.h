//
//  CollectFoodTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleModel.h"
#import "HandInModel.h"
@interface CollectFoodTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *articleImg;
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UILabel *collectTime;

-(void)initCellWithData:(id)model;
@end
