//
//  WelFareInfoListViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/15.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"

@interface WelFareInfoListViewController : HYBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, copy) void(^returnReloadBlock)(void);
@end
