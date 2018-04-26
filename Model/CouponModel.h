//
//  CouponModel.h
//  TheWorker
//
//  Created by yanghao on 2017/10/13.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface CouponModel : BaseModel

@property (nonatomic, retain) NSNumber *Id;
@property (nonatomic, retain) NSNumber *coupon_id;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, retain) NSNumber *price;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, retain) NSNumber *status;
@property (nonatomic, retain) NSNumber *store_id;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *used_time;
@property (nonatomic, copy) NSString *name;



@end
