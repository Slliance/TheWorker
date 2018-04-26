//
//  GoodsViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/25.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "GoodsViewModel.h"
#import "BannerModel.h"
#import "StoreModel.h"
#import "StoreGoodsModel.h"
#import "GoodsRemarkModel.h"
#import "GoodsPropertyModel.h"
#import "PropertyInfoModel.h"
@implementation GoodsViewModel
//员工购物首页
-(void)fetchWorkerShoppingMainpageWithToken:(NSString *)token{
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_store_index method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleStoreListWithPublicModel:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//员工购物首页数据
-(void)handleStoreListWithPublicModel:(PublicModel *)publicModel{
    NSArray *bannerArr = [publicModel.data objectForKey:@"banner"];
    NSArray *storeArr = [publicModel.data objectForKey:@"store_list"];
    
    NSMutableArray *mubannerArr = [[NSMutableArray alloc] init];
    NSMutableArray *muStoreArr = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < bannerArr.count; i ++) {
        BannerModel *model = [[BannerModel alloc] initWithDict:bannerArr[i]];
        [mubannerArr addObject:model];
    }
    
    for (int i = 0; i < storeArr.count; i ++) {
        StoreModel *model = [[StoreModel alloc] initWithDict:storeArr[i]];
        id Id = storeArr[i][@"Id"];
        NSString *storeId = [NSString stringWithFormat:@"%@",Id];
        model.Id = storeId;
        [muStoreArr addObject:model];
    }
    self.returnBlock(@[mubannerArr,muStoreArr]);
}


//店铺列表
-(void)fetchStoreListWithToken:(NSString *)token page:(NSNumber *)page size:(NSNumber *)size{
    NSDictionary *parameter = @{@"token":token,
                                @"page":page,
                                @"size":size};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_store_list method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleStoreListDataWith:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//店铺列表数据
-(void)handleStoreListDataWith:(PublicModel *)publicModel{
    NSArray *array = publicModel.data;
    NSMutableArray *muArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < array.count; i ++) {
        StoreModel *model = [[StoreModel alloc]initWithDict:array[i]];
        id Id = array[i][@"Id"];
        NSString *storeId = [NSString stringWithFormat:@"%@",Id];
        model.Id = storeId;
        [muArr addObject:model];
    }
    self.returnBlock(muArr);
}




//店铺详情
-(void)fetchStoreInfoWithToken:(NSString *)token storeId:(NSString *)Id{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_store_info method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleStoreInfoDataWith:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//店铺详情数据
-(void)handleStoreInfoDataWith:(PublicModel *)publicModel{
    StoreModel *model = [[StoreModel alloc]initWithDict:publicModel.data[@"store"]];
    NSArray *goodsArr = [publicModel.data objectForKey:@"goodsList"];
    NSMutableArray *muGoodsArr = [[NSMutableArray alloc] init];
    NSArray *categoryArr = [publicModel.data objectForKey:@"category"];
    
    for (int i = 0; i < goodsArr.count; i ++) {
        StoreGoodsModel *model = [[StoreGoodsModel alloc] initWithDict:goodsArr[i]];
        [muGoodsArr addObject:model];
    }
    
    self.returnBlock(@[model,muGoodsArr,categoryArr]);
    
}



//商品详情
-(void)fetchGoodsDetailWithToken:(NSString *)token goodsId:(NSString *)goodsId{
    NSDictionary *parameter = @{@"token":token,
                                @"id":goodsId};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_goods_info method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleGoodsDataWith:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleGoodsDataWith:(PublicModel *)publicModel{
    StoreGoodsModel *goodsModel = [[StoreGoodsModel alloc]initWithDict:publicModel.data];
    NSArray *property = publicModel.data[@"property"];
    NSMutableArray *propertyMuArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < property.count; i ++) {
        GoodsPropertyModel *model = [[GoodsPropertyModel alloc]initWithDict:property[i]];
        NSArray *propertyArr = property[i][@"property"];
        NSMutableArray *mupropertyArr = [[NSMutableArray alloc] init];
        for (int j = 0; j < propertyArr.count ; j ++) {
            GoodsPropertyModel *proModel = [[GoodsPropertyModel alloc]initWithDict:propertyArr[j]];
            NSNumber *subId = propertyArr[j][@"property_id"];
            proModel.property_id = [NSString stringWithFormat:@"%@",subId];
            [mupropertyArr addObject:proModel];
        }
        model.property = mupropertyArr;
        [propertyMuArr addObject:model];
    }
    goodsModel.property = propertyMuArr;
    
    NSArray *imgArr = publicModel.data[@"goods_img"];
    goodsModel.goods_img = imgArr;
    NSDictionary *storeDic = publicModel.data[@"store"];
    StoreModel *storeModel = [[StoreModel alloc]initWithDict:storeDic];
    NSString *storeId = storeDic[@"store_id"];
    storeModel.store_id = storeId;
    goodsModel.store = storeModel;
    NSString *goodsId = publicModel.data[@"Id"];
    goodsModel.Id = goodsId;
    self.returnBlock(goodsModel);
}
//获取商品规格详情
-(void)fetchGoodsPropertyDetailWithToken:(NSString *)token propertyId:(NSArray *)propertyId goodsId:(NSString *)goodsId{
    NSDictionary *parameter = @{@"token":token,
                                @"property":propertyId,
                                @"goods_id":goodsId
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_goods_property_info method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handlePropertyDataWith:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handlePropertyDataWith:(PublicModel *)publicModel{
    StoreGoodsModel *model = [[StoreGoodsModel alloc] initWithDict:publicModel.data];
    NSArray *property = publicModel.data[@"property"];
    NSMutableArray *propertyMuArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < property.count; i ++) {
        GoodsPropertyModel *model = [[GoodsPropertyModel alloc]initWithDict:property[i]];
        NSArray *propertyArr = property[i][@"property"];
        NSMutableArray *mupropertyArr = [[NSMutableArray alloc] init];
        for (int j = 0; j < propertyArr.count ; j ++) {
            GoodsPropertyModel *proModel = [[GoodsPropertyModel alloc]initWithDict:propertyArr[j]];
            NSNumber *subId = propertyArr[j][@"property_id"];
            proModel.property_id = [NSString stringWithFormat:@"%@",subId];
            [mupropertyArr addObject:proModel];
        }
        model.property = mupropertyArr;
        [propertyMuArr addObject:model];
    }
    model.property = propertyMuArr;
    self.returnBlock(model);
}



//获取商品评价数据
-(void)fetchGoodsRemarkToken:(NSString *)token goodsId:(NSString *)goodsId page:(NSNumber *)page size:(NSNumber *)size{
    NSDictionary *parameter = @{@"token":token,
                                @"id":goodsId,
                                @"page":page,
                                @"size":size};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_goods_remark method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleGoodsRemarkDataWith:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//商品评论数据
-(void)handleGoodsRemarkDataWith:(PublicModel *)publicModel{
    NSArray *remarkArr = publicModel.data;
    NSMutableArray *muRemarkArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < remarkArr.count; i ++ ) {
        GoodsRemarkModel *model = [[GoodsRemarkModel alloc] initWithDict:remarkArr[i]];
        [muRemarkArr addObject:model];
    }
    self.returnBlock(muRemarkArr);
}






/**
 店铺分类商品列表

 @param token token
 @param storeId 店铺id
 @param page page
 @param size size
 @param categoryId 分类id
 */
-(void)fetchStoreCategoryListWithToken:(NSString *)token storeId:(NSString *)storeId page:(NSNumber *)page size:(NSNumber *)size categoryId:(NSString *)categoryId{
    NSDictionary *parameter = @{@"token":token,
                                @"id":storeId,
                                @"page":page,
                                @"size":size,
                                @"category":categoryId};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_goods_list method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
//商品分类列表数据
-(void)handleGoodsListDataWith:(PublicModel *)publicModel{
    
    NSArray *goodsArr = publicModel.data;
    NSMutableArray *muGoodsArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < goodsArr.count; i ++) {
        StoreGoodsModel *model = [[StoreGoodsModel alloc] initWithDict:goodsArr[i]];
        [muGoodsArr addObject:model];
    }
    
    self.returnBlock(muGoodsArr);
    
}

//搜索商品
-(void)searchGoodsWithName:(NSString *)name Id:(NSString *)Id token:(NSString *)token page:(NSNumber *)page{
    NSDictionary *parameter = @{@"token":token,
                                @"page":page,
                                @"size":@(10),
                                @"name":name};
    NSMutableDictionary *muparameter = [[NSMutableDictionary alloc]initWithDictionary:parameter];
    if (Id) {
        [muparameter setObject:Id forKey:@"store_id"];
    }
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_worker_goods_search method:@"post" parameter:muparameter success:^(NSDictionary *data) {
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
@end
