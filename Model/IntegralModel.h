//
//  IntegralModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/18.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface IntegralModel : BaseModel
@property (nonatomic, retain) NSNumber *score;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, retain) NSNumber *friend_amount;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, retain) NSNumber *remain_score;
@property (nonatomic, retain) NSNumber *score_type;
@end
