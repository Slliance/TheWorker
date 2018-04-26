//
//  RentPersonViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/10.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface RentPersonViewModel : BaseViewModel
//出租人信息
-(void)fetchRentPersonInfomationWithToken:(NSString *)token Id:(NSString *)Id;
//粉丝列表
-(void)fetchRentPersonFansListWithToken:(NSString *)token Id:(NSString *)Id page:(NSNumber *)page size:(NSNumber *)size;
//关注/取消关注
-(void)followPersonWithToken:(NSString *)token Id:(NSString *)Id;
//获取技能价格列表
-(void)fetchRentPersonSkillPriceWithId:(NSString *)Id token:(NSString *)token;

//马上租他
-(void)rentPersonWithToken:(NSString *)token rent_uid:(NSString *)rent_uid start_time:(NSString *)start_time rent_long:(NSString *)rent_long meet_address:(NSString *)meet_address item:(NSString *)item lnk_user:(NSString *)lnk_user lnk_mobile:(NSString *)lnk_mobile msg:(NSString *)msg longitude:(NSNumber *)longitude latitude:(NSNumber *)latitude;
//添加好友
-(void)addFriendWithToken:(NSString *)token Id:(NSString *)Id;

@end
