//
//  PayViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/11/17.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface PayViewModel : BaseViewModel
//租缘订单支付
-(void)goodsPayWithToken:(NSString *)token Id:(NSString *)orderId type:(NSNumber *)type;
//充值
-(void)rechargeWithToken:(NSString *)token money:(NSString *)money type:(NSNumber *)type;
@end
