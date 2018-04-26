//
//  AddressBookFriendModel.h
//  TheWorker
//
//  Created by yanghao on 2017/10/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface AddressBookFriendModel : BaseModel

@property (nonatomic, copy) NSString *friendid;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, retain) NSNumber *user_num;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *headimg;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, retain) NSNumber *status;
@property (nonatomic, copy) NSString *mobile;

@end
