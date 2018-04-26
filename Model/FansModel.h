//
//  FansModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/11.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface FansModel : BaseModel

@property (nonatomic,retain) NSNumber *is_friend;
@property (nonatomic,retain) NSNumber *is_follow;
@property (nonatomic,retain) NSArray *follow_list;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *headimg;
@property (nonatomic, copy) NSString *createtime;
@end
