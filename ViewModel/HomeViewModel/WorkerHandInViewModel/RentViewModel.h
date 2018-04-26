//
//  RentViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/9.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface RentViewModel : BaseViewModel
//租缘吧首页
-(void)fetchRentListWithToken:(NSString *)token page:(NSNumber *)page type:(NSNumber *)type;
//我的形象照片
-(void)fetchMyImageWithToken:(NSString *)token;
//设置为封面图片
-(void)setShowImgWithToken:(NSString *)token show_img:(NSString *)show_img;
//设置个人形象照片
-(void)setOwnerImageWithToken:(NSString *)token img:(NSArray *)img;
//添加个人技能
-(void)addOwnSkillWithToken:(NSString *)token skill:(NSArray *)skill;
//提交出租范围
-(void)submitRentRangeWithToken:(NSString *)token skill:(NSArray *)skill jobSkill:(NSArray *)jobskill friendSkill:(NSArray *)friendskill;
//获取用户出租范围
-(void)fetchOwnRentRangeWithToken:(NSString *)token;
//获取用户未设置价格技能
-(void)fetchUserRentSkillWithToken:(NSString *)token;
@end
