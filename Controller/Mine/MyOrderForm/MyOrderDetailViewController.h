//
//  MyOrderDetailViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"
#import "OrderGoodsModel.h"
#import "GoodsModel.h"
@interface MyOrderDetailViewController : HYBaseViewController

@property (nonatomic, retain) OrderGoodsModel *orderGoodsModel;
@property (nonatomic, retain) GoodsModel *goodsModel;


@property (nonatomic, copy) void (^refreshBlock)(void);
@end
