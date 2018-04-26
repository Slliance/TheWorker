//
//  RechargeViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"

@interface RechargeViewController : HYBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (nonatomic, assign) BOOL isWork; //是否是充值工币
@property (nonatomic, copy)void(^returnReloadBlock)(void);
@end
