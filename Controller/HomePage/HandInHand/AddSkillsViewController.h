//
//  AddSkillsViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"

@interface AddSkillsViewController : HYBaseViewController
@property (nonatomic, retain) NSMutableArray *skillArray;
@property (nonatomic, assign) BOOL friendsOrSkill;
@property (nonatomic, copy) void(^returnBlock)(NSMutableArray *);
@end
