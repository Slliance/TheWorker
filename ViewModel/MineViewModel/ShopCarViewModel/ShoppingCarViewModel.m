//
//  ShoppingCarViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/27.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ShoppingCarViewModel.h"
#import "StoreGoodsModel.h"
#import "StoreModel.h"
@implementation ShoppingCarViewModel

//加入购物车
-(void)addToShoppingCarWithToken:(NSString *)token Id:(NSString *)Id num:(NSNumber *)num property:(NSArray *)property{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id,
                                @"num":num,
                                @"property":property};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_add_car method:@"post" parameter:parameter success:^(NSDictionary *data) {
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



//获取我的购物车数据
-(void)fetchMyShoppingCarWithToken:(NSString *)token page:(NSNumber *)page size:(NSNumber *)size{
    NSDictionary *parameter = @{@"token":token,
                                @"page":page,
                                @"size":size};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_shopping_car method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleGoodsListDataWith:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
    
}
//我的购物车数据
-(void)handleGoodsListDataWith:(PublicModel *)publicModel{
    
    NSArray *storesArr = publicModel.data;
    NSMutableArray *muStoresArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < storesArr.count; i ++) {
        StoreModel *storeModel = [[StoreModel alloc] initWithDict:storesArr[i]];
        NSArray * goodsArr = storesArr[i][@"goods"];
        NSMutableArray *muGoodsArr = [[NSMutableArray alloc]init];
        for (int j = 0; j < goodsArr.count; j ++ ) {
            StoreGoodsModel *model = [[StoreGoodsModel alloc]initWithDict:goodsArr[j]];
            NSArray *array = goodsArr[j][@"goods_property"];
            model.property = array;
            [muGoodsArr addObject:model];
        }
        storeModel.goods = muGoodsArr;
        [muStoresArr addObject:storeModel];
    }
    
    self.returnBlock(muStoresArr);
    
}

//删除购物车
-(void)deleteMyShoppingCarWithToken:(NSString *)token shop:(NSArray *)shop{
    NSDictionary *parameter = @{@"token":token,
                                @"shop":shop};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_shopping_car_delete method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
//修改购物车商品数量
-(void)updateMyShoppingCarWithToken:(NSString *)token Id:(NSString *)Id num:(NSNumber *)num{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id,
                                @"num":num};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_shopping_car_update method:@"post" parameter:parameter success:^(NSDictionary *data) {
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

//修改购物车状态
-(void)changeShopStateWithToken:(NSString *)token Id:(NSString *)Id{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_shopping_car_check method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
@end
