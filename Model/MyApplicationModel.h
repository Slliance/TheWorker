//
//  MyApplicationModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/21.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface MyApplicationModel : BaseModel
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *job_name;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, retain) NSNumber *status;
@property (nonatomic, copy) NSString *nation;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *confirmed_time;
@property (nonatomic, retain) NSNumber *cardno;
@property (nonatomic, copy) NSString *edu;
@property (nonatomic, copy) NSString *interest;
@property (nonatomic, copy) NSString *resume;
@property (nonatomic, retain ) NSNumber *mobile;
@property (nonatomic, retain) NSNumber *sex;
@end
