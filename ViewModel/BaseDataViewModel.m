//
//  BaseDataViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/20.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseDataViewModel.h"
#import "ServiceModel.h"
@implementation BaseDataViewModel
//获取基础数据
-(void)fetchBaseData{
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_base_data method:@"post" parameter:nil success:^(NSDictionary *data) {
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
//我的客服
-(void)fetchMyServiceWithToken:(NSString *)token{
    
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_user_service method:@"post" parameter:@{@"token":token} success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            ServiceModel *model = [[ServiceModel alloc] initWithDict:publicModel.data];
            self.returnBlock(model);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}


@end
