//
//  OrderFormViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/22.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"
#import "StoreGoodsModel.h"
@interface OrderFormViewController : HYBaseViewController

@property (nonatomic, retain) NSArray *goodsArray;

@property (nonatomic, assign) NSInteger isCar;//是否是购物车结算 0否1是;

@property (nonatomic, retain) NSArray *shopIdArray;//购物车ID

@property (nonatomic, copy) void(^returnReloadBlock)(void);
@property (nonatomic, retain) StoreGoodsModel *goodsPropertyModel;
@end
