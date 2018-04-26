//
//  NotMeetViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/13.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"

@interface NotMeetViewController : HYBaseViewController
@property (nonatomic, assign) NSInteger isUserOrRent; //1是我租，2是租我
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) void(^returnBlock)(void);
@end
