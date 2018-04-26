//
//  FriendCircleModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/14.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface FriendCircleModel : BaseModel
@property (nonatomic, copy) NSString        *uid;
@property (nonatomic, copy) NSString        *content;
@property (nonatomic, retain) NSArray        *imgs;
@property (nonatomic, retain) NSArray        *agrees;
@property (nonatomic, retain) NSArray        *follows;
@property (nonatomic, copy) NSString        *createtime;
@property (nonatomic, copy) NSString        *nickname;
@property (nonatomic, copy) NSString        *headimg;
@property (nonatomic, copy) NSString        *friend_id;
@property (nonatomic, copy) NSString        *user_pub_id;
@property (nonatomic, copy) NSString        *atnickname;
@property (nonatomic, copy) NSString        *Id;
@property (nonatomic, retain) NSNumber        *is_agree;
@end
