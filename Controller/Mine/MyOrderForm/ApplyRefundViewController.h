//
//  ApplyRefundViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/4.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"
#import "OrderGoodsModel.h"
#import "StoreGoodsModel.h"
@interface ApplyRefundViewController : HYBaseViewController

@property (nonatomic, retain)OrderGoodsModel *model;
@property (nonatomic, retain) StoreGoodsModel *storeModel;

@property (nonatomic, copy) void(^finishBlock)(void);
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, assign)BOOL applyOnce;
@end
