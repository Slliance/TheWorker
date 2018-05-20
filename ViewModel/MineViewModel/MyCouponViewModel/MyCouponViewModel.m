//
//  MyCouponViewModel.m
//  TheWorker
//
//  Created by yanghao on 2017/10/13.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyCouponViewModel.h"
#import "CouponModel.h"
@implementation MyCouponViewModel
//status 不传默认是全部1-未使用，2-已使用，3-过期
-(void)fetchMyCouponList:(NSInteger)status page:(NSInteger)page token:(NSString *)token{
    NSDictionary *parameter = @{
                                @"page":@(page),
                                @"size":@(10),
                                @"token":token};
    NSMutableDictionary *muparameter = [[NSMutableDictionary alloc] initWithDictionary:parameter];
    if (status != 0) {
        [muparameter setObject:@(status) forKey:@"status"];
    }
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_my_coupon method:@"post" parameter:muparameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleMyCouponList:publicModel];
        }
        else{
            self.errorBlock(publicModel.message);
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleMyCouponList:(PublicModel *)publicModel{
    NSMutableArray *muarr = [[NSMutableArray alloc] init];
    for (int i = 0; i < [publicModel.data count]; i ++) {
        CouponModel *model = [[CouponModel alloc] initWithDict:publicModel.data[i]];
        [muarr addObject:model];
    }
    self.returnBlock(muarr);
}

//领取优惠券
-(void)getCoupon:(NSNumber *)Id token:(NSString *)token{
    NSDictionary *parameter = @{
                                @"id":Id,
                                @"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_get_coupon method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel);
        }
        else{
            self.errorBlock(publicModel.message);
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
    
}
///新人领取优惠券列表
-(void)getNewCouponListWithToken:(NSString *)token{
    NSDictionary *parameter = @{
                                @"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_use_newcoupon method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
             [self handleMyCouponList:publicModel];
        }
        else{
            self.errorBlock(publicModel.message);
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
///一键领取
-(void)receiveNewCouponWithToken:(NSString *)token{
    NSDictionary *parameter = @{
                                @"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_use_receive_newcoupon method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        self.returnBlock(publicModel);
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//使用优惠券
-(void)useCoupon:(NSNumber *)Id token:(NSString *)token shopNO:(NSString *)shopNO{
    NSDictionary *parameter = @{
                                @"id":Id,
                                @"store_num":shopNO,
                                @"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_use_coupon method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel);
        }
        else{
            self.errorBlock(publicModel.message);
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
    
}

@end
