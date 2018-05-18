//
//  StartViewModel.m
//  TheWorker
//
//  Created by yanghao on 9/6/17.
//  Copyright © 2017 huying. All rights reserved.
//

#import "StartViewModel.h"
#import "UserModel.h"

@implementation StartViewModel

//登录
-(void)loginWithMobile:(NSString *)mobile password:(NSString *)password pushCode:(NSString *)pushCode loginWithType:(NSNumber *)loginType thirdId:(NSString *)thirdId{
    NSDictionary *parameter = @{@"mobile":mobile,
                                @"password":password,
                                @"type":loginType,
                                @"uuid":thirdId};
    NSMutableDictionary *muParameter = [[NSMutableDictionary alloc] initWithDictionary:parameter];
    if (pushCode) {
        [muParameter setObject:pushCode forKey:@"pushcode"];
    }
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_login method:@"post" parameter:muParameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            
            [self loginSuccessWithDic:publicModel];
        }
        else if ([publicModel.code integerValue] == 700) {
            
            [self loginWithThird:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//登录成功数据处理
-(void)loginSuccessWithDic: (PublicModel *)publicModel
{
    //对从后台获取的数据进行处理，然后传给ViewController层进行显示
    UserModel *userModel = [[UserModel alloc] initWithDict:publicModel.data];
    
    //保存登录成功后，返回的用户数据
    [UserDefaults writeUserDefaultObjectValue:userModel.im_token withKey:im_token_key];
    
    [UserDefaults writeUserDefaultObjectValue:publicModel.data withKey:user_info];

    NSDictionary *dic = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    self.returnBlock(userModel);
    
}
//第三方登录，去注册
-(void)loginWithThird:(PublicModel *)publicModel{
    self.returnBlock(@"700");
}


//退出登录
-(void)logoutWithId:(NSString *)Id{
    NSDictionary *parameter = @{@"id":Id
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_logout method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self logoutSuccessWithDic:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//退出登录成功数据处理
-(void)logoutSuccessWithDic: (PublicModel *)publicModel
{
    
    [UserDefaults clearUserDefaultWithKey:user_info];
    self.returnBlock(publicModel.message);
    
}


//获取验证码
-(void)fetchMessageVerificationCode:(NSString *)mobile type:(NSString *)type{
    NSDictionary *parameter = @{@"mobile": mobile,
                                @"type":type};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_verification_code method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            
            [self fetchMessageSecutitySuccessWithDic:data];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

//获取邮箱验证码
-(void)fetchEmailVerificationCode:(NSString *)email type:(NSString *)type token:(NSString *)token{
    NSDictionary *parameter = @{@"email": email,
                                @"type":type,
                                @"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_set_verification_code method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            
            [self fetchMessageSecutitySuccessWithDic:data];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];

}
//对验证码数据处理
-(void)fetchMessageSecutitySuccessWithDic: (NSDictionary *) returnValue
{
    PublicModel *publicModel = [self publicModelInitWithData:returnValue];
    self.returnBlock(@[publicModel]);
}



//注册
-(void)registerWithMobile:(NSString *)mobile
                     code:(NSString *)code
                 password:(NSString *)password
                 pushcode:(NSString *)pushcode
                     uuid:(NSString *)uuid
                     type:(NSInteger)type

{
    NSDictionary *parameter = @{@"mobile":mobile,
                                @"code":code,
                                @"type":@(type)
                                };
    NSMutableDictionary *muparameter = [[NSMutableDictionary alloc] initWithDictionary:parameter];
    if (pushcode) {
        [muparameter setObject:pushcode forKey:@"pushcode"];
    }
    if (password) {
        [muparameter setObject:password forKey:@"password"];
    }
    if (uuid) {
        [muparameter setObject:uuid forKey:@"uuid"];
    }
    

    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_register method:@"post" parameter:muparameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self registerSuccessWithDic:publicModel];
            
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//登录成功数据处理
-(void)registerSuccessWithDic: (PublicModel *)publicModel
{
    //对从后台获取的数据进行处理，然后传给ViewController层进行显示
    UserModel *userModel = [[UserModel alloc] initWithDict:publicModel.data];
    userModel.firstlog = @"1";//保存登录成功后，返回的用户数据
    [UserDefaults writeUserDefaultObjectValue:userModel.im_token withKey:im_token_key];
    [UserDefaults writeUserDefaultObjectValue:[userModel dictionaryRepresentation] withKey:user_info];
    self.returnBlock(userModel);
    
}


//忘记密码

-(void)forgetPasswordWithMobile:(NSString *)mobile password:(NSString *)password rePassword:(NSString *)rePassword code:(NSString *)code{
    NSDictionary *parameter = @{@"mobile":mobile,
                                @"code":code,
                                @"repassword":rePassword,
                                @"password":password};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_forgot_pwd method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            
            self.returnBlock(publicModel.message);
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
        
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];

}

-(void)addUserBaseWithToken:(NSString *)token Sex:(NSInteger)sex Birthday:(NSString *)birthday{
    NSDictionary *parameter = @{@"token":token,
                                @"sex":@(sex),
                                @"birthday":birthday};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_addbase method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        self.returnBlock(publicModel);
        
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];

}
@end
