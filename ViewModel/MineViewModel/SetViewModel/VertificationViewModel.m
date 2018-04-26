//
//  VertificationViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/8.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "VertificationViewModel.h"
#import "AuthModel.h"
@implementation VertificationViewModel
//提交用户认证信息
-(void)uploadInfomationWith:(NSString *)name authImg:(NSString *)authImg video:(NSString *)video token:(NSString *)token showImg:(NSString *)show_img{
    NSDictionary *parameter = @{@"name":name,
                                @"auth_img":authImg,
                                @"video":video,
                                @"show_img":show_img,
                                @"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_set_vertification method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            //            [self loginSuccessWithDic:publicModel];
            self.returnBlock(publicModel);
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

//获取用户认证信息
-(void)fetchUserAuthInfomationWithToken:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_auth_info method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            
            [self handleUserAuthInfo:publicModel];
        }
        else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleUserAuthInfo:(PublicModel *)publicModel{
    AuthModel *model = [[AuthModel alloc] initWithDict:publicModel.data];
    self.returnBlock(model);
}
@end
