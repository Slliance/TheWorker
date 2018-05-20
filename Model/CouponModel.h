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
///starttime==endtime 长期有效 否则 2018.01.03-2018.04.07
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, retain) NSNumber *status;
@property (nonatomic, retain) NSNumber *store_id;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *used_time;
///入职体检
@property (nonatomic, copy) NSString *name;
///抽奖券只限于新人领取
@property (nonatomic, copy) NSString *remark;
///抽奖券
@property (nonatomic, copy) NSString *type;

@end
