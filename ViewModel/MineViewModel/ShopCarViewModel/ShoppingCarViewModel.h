//
//  ShoppingCarViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/27.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface ShoppingCarViewModel : BaseViewModel

//加入购物车
-(void)addToShoppingCarWithToken:(NSString *)token Id:(NSString *)Id num:(NSNumber *)num property:(NSArray *)property;

//获取我的购物车数据
-(void)fetchMyShoppingCarWithToken:(NSString *)token page:(NSNumber *) page size:(NSNumber *)size;

//批量删除购物车
-(void)deleteMyShoppingCarWithToken:(NSString *)token shop:(NSArray *)shop;
//修改购物车数量
-(void)updateMyShoppingCarWithToken:(NSString *)token Id:(NSString *)Id num:(NSNumber *)num;
//修改购物车状态
-(void)changeShopStateWithToken:(NSString *)token Id:(NSString *)Id;
@end
