//
//  SaleRecordModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/18.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface SaleRecordModel : BaseModel

@property (nonatomic, retain) NSNumber *amount;
@property (nonatomic, retain) NSNumber *rel_amount;
@property (nonatomic, retain) NSNumber *remain_amount;
@property (nonatomic, retain) NSNumber *trade_type;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, retain) NSNumber *account;
@property (nonatomic, retain) NSNumber *status;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *remark;
@end
