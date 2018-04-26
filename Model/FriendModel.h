//
//  FriendModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface FriendModel : BaseModel
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, retain) NSNumber *status;
@property (nonatomic, copy) NSString *headimg;
@property (nonatomic, retain) NSNumber *sex;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, retain) NSNumber *user_num;
@property (nonatomic, copy) NSString *mobile;

@end
