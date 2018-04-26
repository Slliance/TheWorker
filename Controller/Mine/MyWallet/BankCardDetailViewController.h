//
//  BankCardDetailViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"
#import "BankModel.h"

@interface BankCardDetailViewController : HYBaseViewController
@property (nonatomic, retain)    BankModel *bankModel ;

@property (nonatomic, copy) void(^deleteReturnBlock)();
@end
