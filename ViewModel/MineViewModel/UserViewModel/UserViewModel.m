//
//  UserViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/13.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "UserViewModel.h"
#import "UserModel.h"
@implementation UserViewModel
//获取用户信息
-(void)fetchUserInfomationWithToken:(NSString *)token{
    NSDictionary *parameter = @{@"token":token
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_infomation method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleUserInfo:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleUserInfo:(PublicModel *)publicModel{
    
    //对从后台获取的数据进行处理，然后传给ViewController层进行显示
    NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
        UserModel *model = [[UserModel alloc]initWithDict:userinfo];
        UserModel *userModel = [[UserModel alloc] initWithDict:publicModel.data];    //保存登录成功后，返回的用户数据
    if (userModel.Id) {
        userModel.token = model.token;
        [UserDefaults writeUserDefaultObjectValue:[userModel dictionaryRepresentation] withKey:user_info];
        self.returnBlock(userModel);
    }else{
        self.returnBlock(model);
    }
    
    
}
//获取好友用户信息
-(void)fetchFriendInfomationWithToken:(NSString *)token Id:(NSString *)Id{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_friend_infomation method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleFriendInfoData:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//处理好友用户信息
-(void)handleFriendInfoData:(PublicModel *)publicModel{
    //对从后台获取的数据进行处理，然后传给ViewController层进行显示
    UserModel *userModel = [[UserModel alloc] initWithDict:publicModel.data];    //保存登录成功后，返回的用户数据
    self.returnBlock(userModel);

}
//签到
-(void)userSignWithToken:(NSString *)token{
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_user_sign method:@"post" parameter:@{@"token":token} success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel.message);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//修改签名
-(void)updateSignatureWithToken:(NSString *)token autograph:(NSString *)autograph{
    NSDictionary *parameter = @{@"token":token,
                                @"autograph":autograph};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_user_signature method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel.message);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//查询用户等级
-(void)queryUserGradeWithToken:(NSString *)token{
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_user_grade method:@"post" parameter:@{@"token":token} success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel.data);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

//-(void)handleUserActiveInfomation:(PublicModel *)publicModel{
//    NSString *string = publicModel.data[@"friend_amount"];
////    NSArray
//}


/**
 修改用户信息

 @param headimg 头像
 @param nickname 昵称
 @param sex 性别
 @param constellation 星座
 @param birthday 生日
 @param job 职业
 @param work_address 工作地点
 @param height 身高
 @param sign 签名
 @param zone_code 地区
 */
-(void)updateUserInfomationWithHeadImg:(NSString *)headimg nickname:(NSString *)nickname sex:(NSNumber *)sex constellation:(NSString *)constellation birthday:(NSString *)birthday job:(NSString *)job work_address:(NSString *)work_address height:(NSString *)height sign:(NSString *)sign zone_code:(NSNumber *)zone_code token:(NSString *)token{
    NSDictionary *parameter = @{@"token":token,
                                @"nickname":nickname,
                                @"sex":sex,
                                @"constellation":constellation,
                                @"birthday":birthday,
                                @"job":job,
                                @"work_address":work_address,
                                @"height":height,
                                @"sign":sign,
                                @"zone_code":zone_code,
                                @"headimg":headimg};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_user_update method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel.message);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}





@end
