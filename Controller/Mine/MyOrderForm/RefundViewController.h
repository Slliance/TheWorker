//
//  RefundViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"
#import "OrderGoodsModel.h"
@interface RefundViewController : HYBaseViewController

@property (nonatomic, retain) OrderGoodsModel *model;


@property (nonatomic, assign) NSInteger type;
@end
