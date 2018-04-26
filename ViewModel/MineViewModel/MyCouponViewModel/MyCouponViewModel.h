//
//  MyCouponViewModel.h
//  TheWorker
//
//  Created by yanghao on 2017/10/13.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface MyCouponViewModel : BaseViewModel
-(void)fetchMyCouponList:(NSInteger)status page:(NSInteger)page token:(NSString *)token;

//领取优惠券
-(void)getCoupon:(NSNumber *)Id token:(NSString *)token;

//使用优惠券
-(void)useCoupon:(NSNumber *)Id token:(NSString *)token shopNO:(NSString *)shopNO;
@end
