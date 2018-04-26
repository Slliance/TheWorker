//
//  ScoreOrderModel.h
//  TheWorker
//
//  Created by yanghao on 2017/10/13.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface ScoreOrderModel : BaseModel

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, retain) NSNumber *goods_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *show_img;
@property (nonatomic, retain) NSNumber *status;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *receive_time;
@property (nonatomic, retain) NSNumber *order_no;
@property (nonatomic, retain) NSNumber *mobile;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, retain) NSNumber *friend_amount;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, retain) NSNumber *point;

@end
