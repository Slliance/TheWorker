//
//  RentOrderModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/12.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface RentOrderModel : BaseModel
@property (nonatomic, copy) NSString        *name;
@property (nonatomic, copy) NSString        *nickname;
@property (nonatomic, copy) NSString        *headimg;
@property (nonatomic, copy) NSString        *start_time  ;
@property (nonatomic, copy) NSString        *end_time  ;
@property (nonatomic, copy) NSString        *appointment  ;
@property (nonatomic, copy) NSString        *comment_time  ;
@property (nonatomic, copy) NSString        *user_meeting_time  ;
@property (nonatomic, copy) NSString        *rent_meeting_time  ;
@property (nonatomic, copy) NSString        *user_comment_time  ;
@property (nonatomic, copy) NSString        *rent_comment_time  ;
@property (nonatomic, copy) NSString        *rent_exception_remark  ;
@property (nonatomic, copy) NSString        *user_exception_remark  ;
@property (nonatomic, copy) NSString        *confirmed_time;
@property (nonatomic, copy) NSString        *exception_time;
@property (nonatomic, copy) NSString        *item  ;
@property (nonatomic, copy) NSString        *uid;
@property (nonatomic, copy) NSString        *meet_address;
@property (nonatomic, copy) NSString        *lnk_user;
@property (nonatomic, copy) NSString        *lnk_mobile;
@property (nonatomic, copy) NSString        *msg;
@property (nonatomic, copy) NSString        *user_remark;
@property (nonatomic, copy) NSString        *rent_remark;
@property (nonatomic, copy) NSString        *refund_reason;
@property (nonatomic, copy) NSString        *evaluate;
@property (nonatomic, copy) NSString        *Id;
@property (nonatomic, retain) NSNumber      *type;
@property (nonatomic, retain) NSNumber      *exception_status;
@property (nonatomic, retain) NSNumber      *mobile;
@property (nonatomic, retain) NSNumber      *sex;
@property (nonatomic, retain) NSNumber      *status;
@property (nonatomic, retain) NSNumber      *status2;
@property (nonatomic, retain) NSNumber      *rent_long;
@property (nonatomic, retain) NSNumber      *point;
@property (nonatomic, retain) NSNumber      *rent_point;
@property (nonatomic, retain) NSNumber      *user_point;
@property (nonatomic, retain) NSNumber      *rent_uid;
@property (nonatomic, retain) NSNumber      *longitude;
@property (nonatomic, retain) NSNumber      *latitude;
@property (nonatomic, retain) NSArray       *img;


@end
