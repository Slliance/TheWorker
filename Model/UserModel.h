//
//  UserModel.h
//  jishikangUser
//
//  Created by yanghao on 7/4/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *backup_mobile;
@property (nonatomic, copy) NSString *card_no;
@property (nonatomic, retain) NSNumber *complete;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *markcode;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *work_address;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *im_token;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, retain) NSNumber *zone_code;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, retain) NSNumber *imcode;
@property (nonatomic, retain) NSNumber *friend_amount;
@property (nonatomic, retain) NSNumber *level_id;
@property (nonatomic, retain) NSNumber *user_num;
@property (nonatomic, retain) NSNumber *sex;
@property (nonatomic, copy) NSString *headimg;
@property (nonatomic, copy) NSString *show_img;
@property (nonatomic, copy) NSString *constellation;
@property (nonatomic, retain) NSNumber *age;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, retain) NSNumber *height;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *address_detail;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, retain) NSNumber *sign_in;
@property (nonatomic, retain) NSNumber *auth;
@property (nonatomic, retain) NSNumber *status;
@property (nonatomic, retain) NSNumber *is_friend;

@property (nonatomic, copy) NSString *share;
@property (nonatomic, copy) NSString *share_content;
@property (nonatomic, copy) NSString *share_title;
///1:已经填写简历，0：未填写
@property(nonatomic,assign)NSInteger resume;
///1：已经填写牵手信息，0：未填写
@property(nonatomic,assign)NSInteger fate;

@end
