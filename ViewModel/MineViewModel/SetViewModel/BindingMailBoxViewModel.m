//
//  BindingMailBoxViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/7.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BindingMailBoxViewModel.h"

@implementation BindingMailBoxViewModel
-(void)bindingMailBoxWithStep:(NSString *)step email:(NSString *)email emailCode:(NSString *)emailCode mobileCode:(NSString *)mobileCode token:(NSString *)token{
    NSDictionary *parameter = @{@"step":step,
                                @"token":token};
    NSMutableDictionary *muParameter = [[NSMutableDictionary alloc]initWithDictionary:parameter];
    if (email) {
        [muParameter setObject:email forKey:@"email"];
    }
    if (emailCode) {
        [muParameter setObject:emailCode forKey:@"email_code"];
    }
    if (mobileCode) {
        [muParameter setObject:mobileCode forKey:@"sms_code"];
    }
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_set_mail method:@"post" parameter:muParameter success:^(NSDictionary *data) {
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
