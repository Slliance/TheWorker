//
//  ShopListTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/17.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreModel.h"
@interface ShopListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shopImg;
@property (weak, nonatomic) IBOutlet UILabel *labelShopName;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UILabel *labelGray;
-(void)initCellWithData:(StoreModel *)model;
@end
