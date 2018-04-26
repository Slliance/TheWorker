//
//  AddressViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/28.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface AddressViewModel : BaseViewModel
//新增收货地址
-(void)addNewOrderAddressWithToken:(NSString *)token name:(NSString *)name mobile:(NSString *)mobile zone_code:(NSString *)zone_code address_detail:(NSString *)address_detail is_def:(NSInteger)is_def;

//我的收货地址列表
-(void)fetchMyOrderAddressListWithToken:(NSString *)token;

//设置为默认收货地址
-(void)setDetaultAddressWithToken:(NSString *)token Id:(NSString *)Id;

//删除收货地址
-(void)deleteAddressWithToken:(NSString *)token Id:(NSString *)Id;

//修改收货地址
-(void)updateOrderAddressWithToken:(NSString *)token name:(NSString *)name mobile:(NSString *)mobile zone_code:(NSString *)zone_code address_detail:(NSString *)address_detail is_def:(NSInteger)is_def Id:(NSString *)Id;

//默认收货地址
-(void)fetchMydefaultAddressWithToken:(NSString *)token;
@end
