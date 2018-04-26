//
//  OrderViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/29.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface OrderViewModel : BaseViewModel

//立即购买添加订单
-(void)buyNowAddOrderWithToken:(NSString *)token goodsId:(NSString *)goodsId num:(NSNumber *)num property:(NSArray *)property add_id:(NSString *)add_id;

//从购物车添加订单
-(void)buyFromShoppingCarWithToken:(NSString *)token shop_id:(NSArray *)shop_id add_id:(NSString *)add_id;

//确认订单
-(void)confirmOrderWithToken:(NSString *)token shop_id:(NSArray *)shop_id;

//获取我的订单列表
-(void)fetchMyOrderList:(NSString *)token page:(NSInteger)page status:(NSInteger)status;
//我的积分订单列表  订单状态 ：0=待领取，1=已领取，2=全部
-(void)fetchMyScoreOrderList:(NSString *)token status:(NSInteger)status page:(NSInteger)page;

//取消订单
-(void)cancelOrder:(NSString *)Id token:(NSString *)token;

//普通订单详情
-(void)fetchOrderDetail:(NSString *)Id token:(NSString *)token;

//积分订单详情
-(void)fetchScoreOrderDetail:(NSString *)Id token:(NSString *)token;

//商品订单支付
-(void)payOrderPay:(NSArray *)Id type:(NSInteger)type token:(NSString *)token;

//确认收货
-(void)confirmGet:(NSString *)Id token:(NSString *)token;

//订单评价
-(void)commitComment:(NSString *)Id token:(NSString *)token goods:(NSArray *)goods;

//再次购买
-(void)buyAgain:(NSString *)Id token:(NSString *)token type:(NSInteger)type;

//退款原因
-(void)fetchRefundReason:(NSString *)token;

//申请退款
-(void)applyRefund:(NSString *)Id
             token:(NSString *)token
       user_reason:(NSString *)user_reason
            remark:(NSString *)remark
               img:(NSArray *)img
              type:(NSInteger)type;
//再次申请退款
-(void)applyOnceRefund:(NSString *)Id
                 token:(NSString *)token
           user_reason:(NSString *)user_reason
                remark:(NSString *)remark
                   img:(NSArray *)img
                  type:(NSInteger)type;
//退款订单获取价格
-(void)fetchRefundOrderPrice:(NSString *)Id token:(NSString *)token type:(NSInteger)type;

//领取积分商品
-(void)getPointGoodsWithToken:(NSString *)token Id:(NSString *)Id;
@end
