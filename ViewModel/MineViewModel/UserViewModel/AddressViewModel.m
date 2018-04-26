//
//  AddressViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/28.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "AddressViewModel.h"
#import "AddressModel.h"
@implementation AddressViewModel


/**
 添加收货地址

 @param token token
 @param name 联系人
 @param mobile 电话
 @param zone_code 地区code
 @param address_detail 详细地址
 */
-(void)addNewOrderAddressWithToken:(NSString *)token name:(NSString *)name mobile:(NSString *)mobile zone_code:(NSString *)zone_code address_detail:(NSString *)address_detail is_def:(NSInteger)is_def{
    NSDictionary *parameter = @{@"token":token,
                                @"name":name,
                                @"mobile":mobile,
                                @"zone_code":zone_code,
                                @"address_detail":address_detail,
                                @"is_def":@(is_def)};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_add_address method:@"post" parameter:parameter success:^(NSDictionary *data) {
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



//获取我的收货地址
-(void)fetchMyOrderAddressListWithToken:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_address_list method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleMyAddressData:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleMyAddressData:(PublicModel *)publicModel{
    NSArray *addArr = publicModel.data;
    NSMutableArray *muAddArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < addArr.count; i ++) {
        AddressModel *model = [[AddressModel alloc]initWithDict:addArr[i]];
        [muAddArr addObject:model];
    }
    self.returnBlock(muAddArr);
}




/**
 设置为默认收货地址

 @param token token
 @param Id 地址id
 */
-(void)setDetaultAddressWithToken:(NSString *)token Id:(NSString *)Id{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_address_default method:@"post" parameter:parameter success:^(NSDictionary *data) {
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

/**
 删除收货地址

 @param token token
 @param Id 地址id
 */
-(void)deleteAddressWithToken:(NSString *)token Id:(NSString *)Id{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_address_delete method:@"post" parameter:parameter success:^(NSDictionary *data) {
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

//修改收货地址
-(void)updateOrderAddressWithToken:(NSString *)token name:(NSString *)name mobile:(NSString *)mobile zone_code:(NSString *)zone_code address_detail:(NSString *)address_detail is_def:(NSInteger)is_def Id:(NSString *)Id{
    NSDictionary *parameter = @{@"token":token,
                                @"name":name,
                                @"mobile":mobile,
                                @"zone_code":zone_code,
                                @"address_detail":address_detail,
                                @"is_def":@(is_def),
                                @"id":Id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_address_update method:@"post" parameter:parameter success:^(NSDictionary *data) {
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



//获取默认收货地址
-(void)fetchMydefaultAddressWithToken:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_address_mydefault method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            AddressModel *model = [[AddressModel alloc]initWithDict:publicModel.data];
            self.returnBlock(model);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];

}

@end
