//
//  JobChooseViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"

@interface JobChooseViewController : HYBaseViewController
@property (nonatomic, copy) void(^returnText)(NSString *,NSInteger);
@property (nonatomic, assign) NSInteger currentSelectIndex;
@property (nonatomic, assign) NSInteger currentSelectType;
@end
