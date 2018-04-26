//
//  OrderGoodsModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface OrderGoodsModel : BaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *trans_order_no;
@property (nonatomic, retain) NSNumber *price;
@property (nonatomic, retain) NSNumber *return_price;
@property (nonatomic, retain) NSNumber *goods_number;
@property (nonatomic, retain) NSNumber *trans_price;
@property (nonatomic, retain) NSNumber *store_id;
@property (nonatomic, retain) NSNumber *point;
@property (nonatomic, retain) NSArray *goods;

@property (nonatomic, retain) NSNumber *status;
@property (nonatomic, retain) NSNumber *refund_status;//是否申请售后  0=未申请 1= 申请


@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *order_no;
@property (nonatomic, copy) NSString *refund_no;
@property (nonatomic, copy) NSString *store_name;

//订单状态 ：0-全部， 1-待支付 ,2- 已支付待发货 ,3-待收货, 4-已完成
@property (nonatomic, retain) NSNumber *order_status;


@property (nonatomic, copy) NSString *reason;
@property (nonatomic, retain) NSNumber *refund_price;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, retain) NSArray *imgs;
@property (nonatomic, copy) NSString *user_reason;

@property (nonatomic, copy) NSString *company;

@end
