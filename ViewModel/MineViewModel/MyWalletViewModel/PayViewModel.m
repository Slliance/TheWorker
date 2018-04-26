//
//  PayViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/11/17.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "PayViewModel.h"

@implementation PayViewModel
//租缘订单支付
-(void)goodsPayWithToken:(NSString *)token Id:(NSString *)orderId type:(NSNumber *)type{
    NSDictionary *parameter = @{@"token":token,
                                @"id":orderId,
                                @"type":type
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_order_rent_goodspay method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
//充值
-(void)rechargeWithToken:(NSString *)token money:(NSString *)money type:(NSNumber *)type{
    NSDictionary *parameter = @{@"token":token,
                                @"money":money,
                                @"type":type
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_user_wallet_recharge method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
@end
