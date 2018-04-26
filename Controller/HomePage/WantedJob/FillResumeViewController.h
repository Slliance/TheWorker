//
//  FillResumeViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/30.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"

@interface FillResumeViewController : HYBaseViewController
@property (nonatomic, copy) void(^returnResumeBlock)(NSString *);
@end
