//
//  CreateOwnSkillViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"

@interface CreateOwnSkillViewController : HYBaseViewController
@property (nonatomic, copy) void(^returnSkillBlock)(NSMutableArray *);
@end
