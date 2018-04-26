//
//  ScoreOrderDetailViewController.h
//  TheWorker
//
//  Created by yanghao on 2017/10/14.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"
#import "ScoreOrderModel.h"
@interface ScoreOrderDetailViewController : HYBaseViewController

@property (nonatomic, retain)ScoreOrderModel *scoreOrderModel;
@property (nonatomic, assign) NSInteger isConverted;
@property (nonatomic, copy) void (^returnBlock)(void);
@end
