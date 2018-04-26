//
//  MyCartTableViewCell.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreGoodsModel.h"
@interface MyCartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *labelAmount;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UIButton *btnMinus;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *labelProperty;

@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, retain) StoreGoodsModel *storeGoodsModel;

@property (nonatomic, copy) void(^returnBlock)(NSInteger,NSInteger,NSString *);
@property (nonatomic, copy) void(^msgBlock)(NSString *);
-(void)initCellWithData:(StoreGoodsModel *)model;
@end
