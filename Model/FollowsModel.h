//
//  FollowsModel.h
//  TheWorker
//
//  Created by yanghao on 9/20/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "BaseModel.h"

@interface FollowsModel : BaseModel
@property (nonatomic, copy) NSString        *Id;
@property (nonatomic, copy) NSString        *atnickname;
@property (nonatomic, copy) NSString        *content;
@property (nonatomic, copy) NSString        *friend_id;
@property (nonatomic, copy) NSString        *nickname;
@property (nonatomic, copy) NSString        *uid;
@property (nonatomic, copy) NSString        *user_pub_id;

@end
