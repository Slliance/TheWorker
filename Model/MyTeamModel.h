//
//  MyTeamModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 14/12/2017.
//  Copyright © 2017 huying. All rights reserved.
//

#import "BaseModel.h"

@interface MyTeamModel : BaseModel
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, retain) NSNumber *num;
@property (nonatomic, retain) NSNumber *remain_score;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *pmobile;

@end
