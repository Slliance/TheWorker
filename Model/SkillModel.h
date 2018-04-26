//
//  SkillModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/10.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface SkillModel : BaseModel
@property (nonatomic ,copy) NSString *skill;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic, retain) NSNumber *price;
@property (nonatomic, retain) NSNumber *skill_id;
@property (nonatomic, retain) NSNumber *Id;
@end
