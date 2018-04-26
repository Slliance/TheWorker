//
//  RemarkViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/5.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"
#import "OrderGoodsModel.h"
#import "StoreGoodsModel.h"
@interface RemarkViewController : HYBaseViewController

@property (nonatomic, copy) void(^finishBlock)(void);
@property (nonatomic, retain) OrderGoodsModel *model;
@property (nonatomic, retain) StoreGoodsModel *storeModel;

@property (nonatomic, assign)  BOOL  isSmallOrder;

@end

