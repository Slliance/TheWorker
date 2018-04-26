//
//  GoodsViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/25.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface GoodsViewModel : BaseViewModel
//员工购物首页
-(void)fetchWorkerShoppingMainpageWithToken:(NSString *)token;

//店铺列表
-(void)fetchStoreListWithToken:(NSString *)token page:(NSNumber *)page size:(NSNumber *)size;

//店铺详情
-(void)fetchStoreInfoWithToken:(NSString *)token storeId:(NSString *)Id;

//商品详情
-(void)fetchGoodsDetailWithToken:(NSString *)token goodsId:(NSString *)goodsId;
//获取商品规格详情
-(void)fetchGoodsPropertyDetailWithToken:(NSString *)token propertyId:(NSArray *)propertyId goodsId:(NSString *)goodsId;
//获取商品评价
-(void)fetchGoodsRemarkToken:(NSString *)token goodsId:(NSString *)goodsId page:(NSNumber *)page size:(NSNumber *)size;

//店铺商品分类列表
-(void)fetchStoreCategoryListWithToken:(NSString *)token storeId:(NSString *)storeId page:(NSNumber *)page size:(NSNumber *)size categoryId:(NSString *)categoryId;

//搜索商品
-(void)searchGoodsWithName:(NSString *)name Id:(NSString *)Id token:(NSString *)token page:(NSNumber *)page;
@end
