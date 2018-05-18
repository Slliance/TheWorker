//
//  StartViewModel.h
//  TheWorker
//
//  Created by yanghao on 9/6/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface StartViewModel : BaseViewModel

//登录
-(void)loginWithMobile:(NSString *)mobile password:(NSString *)password pushCode:(NSString *)pushCode loginWithType:(NSNumber *)loginType thirdId:(NSString *)thirdId;

//退出登录
-(void)logoutWithId:(NSString *)Id;


//注册
-(void)registerWithMobile:(NSString *)mobile
                     code:(NSString *)code
                 password:(NSString *)password
                 pushcode:(NSString *)pushcode
                     uuid:(NSString *)uuid
                     type:(NSInteger)type;

//获取验证码
-(void)fetchMessageVerificationCode:(NSString *)mobile type:(NSString *)type;
//获取邮箱验证码
-(void)fetchEmailVerificationCode:(NSString *)email type:(NSString *)type token:(NSString *)token;

//忘记密码
-(void)forgetPasswordWithMobile:(NSString *)mobile password:(NSString *)password rePassword:(NSString *)rePassword code:(NSString *)code;
///第一次进入填写性别
-(void)addUserBaseWithToken:(NSString *)token Sex:(NSInteger)sex Birthday:(NSString *)birthday;

@end
