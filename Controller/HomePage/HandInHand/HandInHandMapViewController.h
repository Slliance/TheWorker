//
//  HandInHandMapViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/30.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"
#import "RentMapModel.h"
@interface HandInHandMapViewController : HYBaseViewController
@property (nonatomic, retain) RentMapModel *mapModel;
@property (nonatomic, copy) void(^returnMapModel)(RentMapModel *);
@end
