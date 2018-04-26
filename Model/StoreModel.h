//
//  StoreModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/25.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface StoreModel : BaseModel
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *describ;
@property (nonatomic, retain) NSNumber *score;
@property (nonatomic, retain) NSNumber *wechat;
@property (nonatomic, retain) NSNumber *qq;
@property (nonatomic, retain) NSNumber *uid;
@property (nonatomic, retain) NSNumber *user_num;
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *user_mobile;
@property (nonatomic, retain) NSNumber *is_friend;
@property (nonatomic, retain) NSArray *goods;
@end
