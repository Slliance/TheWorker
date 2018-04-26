//
//  OrderViewModel.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "OrderViewModel.h"
#import "OrderGoodsModel.h"//订单商店model 名字错了
#import "StoreGoodsModel.h"
#import "ScoreOrderModel.h"
#import "RefundReasonModel.h"

@implementation OrderViewModel

//立即购买添加订单
-(void)buyNowAddOrderWithToken:(NSString *)token goodsId:(NSString *)goodsId num:(NSNumber *)num property:(NSArray *)property add_id:(NSString *)add_id{
    NSDictionary *parameter = @{@"token":token,
                                @"id":goodsId,
                                @"num":num,
                                @"property":property,
                                @"add_id":add_id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_order_addOrder method:@"post" parameter:parameter success:^(NSDictionary *data) {
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

//从购物车提交订单
-(void)buyFromShoppingCarWithToken:(NSString *)token shop_id:(NSArray *)shop_id add_id:(NSString *)add_id{
    NSDictionary *parameter = @{@"token":token,
                                @"shop_id":shop_id,
                                @"add_id":add_id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_order_addShopOrder method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
//确认订单
-(void)confirmOrderWithToken:(NSString *)token shop_id:(NSArray *)shop_id{
    NSDictionary *parameter = @{@"token":token,
                                @"shop_id":shop_id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_confirm_order method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleOrderInfomation:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleOrderInfomation:(PublicModel *)publicModel{
    NSArray *storeArr = publicModel.data;
    NSMutableArray *muStoreArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < storeArr.count; i ++) {
        OrderGoodsModel *storeModel = [[OrderGoodsModel alloc]initWithDict:storeArr[i]];
        NSArray *goodsArr = storeArr[i][@"goods"];
        NSMutableArray *muGoodsArr = [[NSMutableArray alloc]init];
        for (int j = 0; j < goodsArr.count; j ++) {
            StoreGoodsModel *model = [[StoreGoodsModel alloc]initWithDict:goodsArr[j]];
            NSArray *propertyArr = goodsArr[j][@"property_tag"];
            model.property_tag = propertyArr;
            [muGoodsArr addObject:model];
        }
        storeModel.goods = muGoodsArr;
        storeModel.price = storeArr[i][@"price"];
        storeModel.trans_price = storeArr[i][@"trans_price"];
        [muStoreArr addObject:storeModel];
    }
    self.returnBlock(muStoreArr);
}

//我的订单列表
-(void)fetchMyOrderList:(NSString *)token page:(NSInteger)page status:(NSInteger)status{
    
    NSDictionary *parameter = @{@"token":token,
                                @"page":@(page),
                                @"status":@(status),
                                @"size":@(10)};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_order_list method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleMyOrderList:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
//处理我的订单列表返回的数据
-(void)handleMyOrderList:(PublicModel *)publicModel{
    
    NSMutableArray *muarr = [[NSMutableArray alloc] init];
    for (int i = 0; i < [publicModel.data count]; i ++) {
        OrderGoodsModel *model = [[OrderGoodsModel alloc] initWithDict:publicModel.data[i]];
        NSMutableArray *mugoods  = [[NSMutableArray alloc] init];
        NSArray *goods = [publicModel.data[i] objectForKey:@"goods"];
        NSArray *imgs = [publicModel.data[i] objectForKey:@"imgs"];
        for (int j = 0; j < goods.count; j ++) {
            StoreGoodsModel *goodModel = [[StoreGoodsModel alloc] initWithDict:goods[j]];
            goodModel.property = [goods[j] objectForKey:@"property"];
            goodModel.property_tag = [goods[j] objectForKey:@"property_tag"];
            [mugoods addObject:goodModel];
        }
        
        NSMutableArray *muImgs  = [[NSMutableArray alloc] init];

        for (int j = 0; j < imgs.count; j ++) {
            [muImgs addObject:imgs[j]];
        }
        model.imgs = muImgs;
        model.goods = mugoods;
        [muarr addObject:model];
    }
    self.returnBlock(muarr);
    
}


//我的积分订单列表  订单状态 ：0=待领取，1=已领取，2=全部
-(void)fetchMyScoreOrderList:(NSString *)token status:(NSInteger)status page:(NSInteger)page{
    
    NSDictionary *parameter = @{@"token":token,
                                @"page":@(page),
                                @"status":@(status),
                                @"size":@(10)};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_mine_score_order_list method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleMyScoreOrderList:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

//处理我的订单列表返回的数据
-(void)handleMyScoreOrderList:(PublicModel *)publicModel{
    
    NSMutableArray *muarr = [[NSMutableArray alloc] init];
    for (int i = 0; i < [publicModel.data count]; i ++) {
        ScoreOrderModel *model = [[ScoreOrderModel alloc] initWithDict:publicModel.data[i]];
        [muarr addObject:model];
    }
    self.returnBlock(muarr);
}


//取消订单
-(void)cancelOrder:(NSString *)Id token:(NSString *)token{
    NSDictionary *parameter = @{@"token":token,@"id":Id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_cancel_order method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

//普通订单详情
-(void)fetchOrderDetail:(NSString *)Id token:(NSString *)token{
    
    NSDictionary *parameter = @{@"token":token,@"id":Id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_order_detail method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleOrderDetail:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
    
}
//处理订单详情返回的数据
-(void)handleOrderDetail:(PublicModel *)publicModel{
    
    OrderGoodsModel *model = [[OrderGoodsModel alloc] initWithDict:publicModel.data];
    NSMutableArray *mugoods  = [[NSMutableArray alloc] init];
    NSArray *goods = [publicModel.data objectForKey:@"goods"];
    for (int j = 0; j < goods.count; j ++) {
        StoreGoodsModel *goodModel = [[StoreGoodsModel alloc] initWithDict:goods[j]];
        goodModel.property = [goods[j] objectForKey:@"property"];
        goodModel.property_tag = [goods[j] objectForKey:@"property_tag"];
        [mugoods addObject:goodModel];
    }
    model.goods = mugoods;
    self.returnBlock(model);
}


//积分订单详情
-(void)fetchScoreOrderDetail:(NSString *)Id token:(NSString *)token{
    
    NSDictionary *parameter = @{@"token":token,@"id":Id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_score_order_detail method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleScoreOrderData:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}
-(void)handleScoreOrderData:(PublicModel *)publicModel{
    ScoreOrderModel *model = [[ScoreOrderModel alloc] initWithDict:publicModel.data];
    self.returnBlock(model);
}

//商品订单支付
-(void)payOrderPay:(NSArray *)Id type:(NSInteger)type token:(NSString *)token{
    NSDictionary *parameter = @{@"id":Id,
                                @"token":token,
                                @"type":@(type)};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_order_pay method:@"post" parameter:parameter success:^(NSDictionary *data) {
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


//确认收货
-(void)confirmGet:(NSString *)Id token:(NSString *)token{
    
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_confirm_get method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];

}
//提交评价
-(void)commitComment:(NSString *)Id token:(NSString *)token goods:(NSArray *)goods{
    
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id,
                                @"goods":goods};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_order_comment method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];

}

//再次购买
-(void)buyAgain:(NSString *)Id token:(NSString *)token type:(NSInteger)type{
    
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id,
                                @"type":@(type)};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_buy_again method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

//退款原因
-(void)fetchRefundReason:(NSString *)token{
    
    NSDictionary *parameter = @{@"token":token};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_refund_reason method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleRefundReason:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
}

-(void)handleRefundReason:(PublicModel *)publicModel{
    
    NSMutableArray *muArr  = [[NSMutableArray alloc] init];
    for (int j = 0; j < [publicModel.data count]; j ++) {
        RefundReasonModel *model = [[RefundReasonModel alloc] initWithDict:publicModel.data[j]];
        [muArr addObject:model];
    }
    self.returnBlock(muArr);
}

//申请退款
-(void)applyRefund:(NSString *)Id
             token:(NSString *)token
       user_reason:(NSString *)user_reason
            remark:(NSString *)remark
               img:(NSArray *)img
              type:(NSInteger)type


{
    
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id,
                                @"user_reason":user_reason,
                                @"remark":remark,
                                @"img":img,
                                @"type":@(type)
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_apply_refund method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];

    
}



//再次申请退款
-(void)applyOnceRefund:(NSString *)Id
                 token:(NSString *)token
           user_reason:(NSString *)user_reason
                remark:(NSString *)remark
                   img:(NSArray *)img
                  type:(NSInteger)type


{
    
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id,
                                @"user_reason":user_reason,
                                @"remark":remark,
                                @"img":img
                                
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_apply_refund_once method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            self.returnBlock(publicModel);
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];
    
    
}


//退款订单获取价格
-(void)fetchRefundOrderPrice:(NSString *)Id token:(NSString *)token type:(NSInteger)type{
    
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id,
                                @"type":@(type)
                                };
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_order_refund_price method:@"post" parameter:parameter success:^(NSDictionary *data) {
        PublicModel *publicModel = [self publicModelInitWithData:data];
        if ([publicModel.code integerValue] == CODE_SUCCESS) {
            [self handleRefundReason:publicModel];
        }else{
            [self errorCodeWithDescribe:publicModel.message];
        }
    } fail:^(NSString *error) {
        [self errorCodeWithDescribe:error];
    }];

    
    
}
//领取积分商品
-(void)getPointGoodsWithToken:(NSString *)token Id:(NSString *)Id{
    NSDictionary *parameter = @{@"token":token,
                                @"id":Id};
    [[HYNetwork sharedHYNetwork] sendRequestWithURL:url_order_get_goods method:@"post" parameter:parameter success:^(NSDictionary *data) {
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
