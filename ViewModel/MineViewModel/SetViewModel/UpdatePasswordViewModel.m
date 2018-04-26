//
//  UpdatePasswordViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/7.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "UpdatePasswordViewModel.h"

@implementation UpdatePasswordViewModel
-(void)updatePasswordWithToken:(NSString *)token oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword rePassword:(NSString *)rePassword{
    NSDictionary *parameter = @{@"oldpassword":oldPassword,
                                @"newpassword":newPassword,
                                @"repassword":rePassword,
                                @"token":token};
        [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_set_change_password method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
@end
