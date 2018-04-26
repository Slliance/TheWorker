//
//  ResumeModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/20.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface ResumeModel : BaseModel
@property (nonatomic, copy) NSString *resume;
@property (nonatomic, copy) NSString *interest;
@property (nonatomic, copy) NSString *nation;
@property (nonatomic, copy) NSString *cardno;
@property (nonatomic, copy) NSString *edu;
@property (nonatomic, copy) NSString *recommend_user;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSNumber *sex;
@property (nonatomic, copy) NSString *mobile;


@end
