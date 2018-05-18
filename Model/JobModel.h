//
//  JobModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/19.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface JobModel : BaseModel
@property (nonatomic, retain) NSNumber *company_id;
@property (nonatomic, retain) NSNumber *min_wages;
@property (nonatomic, retain) NSNumber *max_wages;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSNumber *click_count;
@property (nonatomic, copy) NSString *work_time;
@property (nonatomic, retain) NSNumber *remain_score;
@property (nonatomic, copy) NSString *valid_time;
@property (nonatomic, retain) NSNumber *count;
@property (nonatomic, retain) NSNumber *job_type;
@property (nonatomic, retain) NSNumber *trade;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *discreble;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSNumber *Id;
@property (nonatomic, retain) NSNumber *is_collect;
@property (nonatomic, copy) NSString *company_describale;
///
//@property (nonatomic, copy) NSString *companys_describale;
@property (nonatomic, copy) NSString *collect_id;
///分享URL
@property (nonatomic,copy)NSString *shared_address;
@end
