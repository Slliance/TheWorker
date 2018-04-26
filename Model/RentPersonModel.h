//
//  RentPersonModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/10.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface RentPersonModel : BaseModel
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *showimg;
@property (nonatomic, copy) NSString *constellation;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *work_address;
@property (nonatomic, copy) NSString *headimg;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *share;
@property (nonatomic, retain) NSNumber *trust;
@property (nonatomic, retain) NSNumber *sex;
@property (nonatomic, retain) NSNumber *height;
@property (nonatomic, retain) NSNumber *age;
@property (nonatomic, retain) NSNumber *is_friend;
@property (nonatomic, retain) NSNumber *is_follow;
@property (nonatomic, retain) NSArray *tag;
@property (nonatomic, retain) NSArray *server;

@end
