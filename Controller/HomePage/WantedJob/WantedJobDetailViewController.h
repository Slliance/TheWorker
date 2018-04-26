//
//  WantedJobDetailViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"
#import "JobModel.h"
@interface WantedJobDetailViewController : HYBaseViewController
@property (nonatomic, retain) JobModel *jobModel;
@property (nonatomic, copy) void(^returnReloadBlock)(JobModel *);
@end
