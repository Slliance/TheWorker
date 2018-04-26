//
//  RentOrderViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/11.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"
#import "RentPersonModel.h"
#import "SkillModel.h"
@interface RentOrderViewController : HYBaseViewController
@property (nonatomic, retain) RentPersonModel *personModel;
@property (nonatomic, retain) NSArray *skillArray;
@property (nonatomic, retain) SkillModel *selectModel;

@end
