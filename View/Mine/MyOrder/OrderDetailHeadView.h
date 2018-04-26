//
//  OrderDetailHeadView.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderGoodsModel.h"
@interface OrderDetailHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelTel;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;


-(void)initView:(OrderGoodsModel *)model;
@end
