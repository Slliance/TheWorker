//
//  UserViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/13.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface UserViewModel : BaseViewModel
//获取用户信息(自己)
-(void)fetchUserInfomationWithToken:(NSString *)token;
//获取用户信息(别人的)
-(void)fetchFriendInfomationWithToken:(NSString *)token Id:(NSString *)Id;
//用户签到
-(void)userSignWithToken:(NSString *)token;
//修改签名
-(void)updateSignatureWithToken:(NSString *)token autograph:(NSString *)autograph;
//查询用户活跃信息
-(void)queryUserGradeWithToken:(NSString *)token;
//更新用户信息
-(void)updateUserInfomationWithHeadImg:(NSString *)headimg nickname:(NSString *)nickname sex:(NSNumber *)sex constellation:(NSString *)constellation birthday:(NSString *)birthday job:(NSString *)job work_address:(NSString *)work_address height:(NSString *)height  sign:(NSString *)sign zone_code:(NSNumber *)zone_code token:(NSString *)token;
@end
