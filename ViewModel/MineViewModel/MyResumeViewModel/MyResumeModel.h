//
//  MyResumeModel.h
//  TheWorker
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 huying. All rights reserved.
//

#import "BaseModel.h"

@interface MyResumeModel : BaseModel
///名字
@property(nonatomic,copy)NSString *name;
///身份证
@property(nonatomic,copy)NSString *cardno;
///学历
@property(nonatomic,copy)NSString *edu;
///民族
@property(nonatomic,copy)NSString *nation;
///兴趣
@property(nonatomic,copy)NSString *interest;
///自我介绍
@property(nonatomic,copy)NSString *introduction;
///手机
@property(nonatomic,copy)NSString *mobile;
///性别
@property(nonatomic,copy)NSString *sex;
///推荐人
@property(nonatomic,copy)NSString *recommend_user;
///职位
@property(nonatomic,copy)NSString *job_name;
///期望工资
@property(nonatomic,copy)NSString *salary;
///身份证照片
@property(nonatomic,copy)NSArray *card_img;
///健康证号
@property(nonatomic,copy)NSString *heathly_no;
///技能证书
@property(nonatomic,copy)NSString *skill_img;

@end
