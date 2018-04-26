//
//  RewardModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/11/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface RewardModel : BaseModel
@property (nonatomic, retain) NSNumber *amount;
@property (nonatomic, retain) NSNumber *remain_amount;
@property (nonatomic, copy) NSString *createtime;
@end
