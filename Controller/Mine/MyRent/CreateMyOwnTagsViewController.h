//
//  CreateMyOwnTagsViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/13.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"

@interface CreateMyOwnTagsViewController : HYBaseViewController
@property (nonatomic, copy) void(^returnSkillBlock)(NSMutableArray *);
@end
