//
//  MyRentViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/11.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface MyRentViewModel : BaseViewModel
//我的租赁
-(void)fetchMyRentInfoWithToken:(NSString *)token;
//我的租赁订单
-(void)fetchMyRentOrderWithToken:(NSString *)token status:(NSNumber *)status tag:(NSNumber *)tag page:(NSNumber *)page;
//租赁订单详情
-(void)fetchMyRentOrderDetailWithToken:(NSString *)token Id:(NSString *)Id type:(NSNumber *)type;
//处理订单
-(void)handleMyRentOrderWithToken:(NSString *)token Id:(NSString *)Id arrange:(NSNumber *)arrange refundReason:(NSString *)refundReason;
//取消订单
-(void)cancelMyRentOrderWithToken:(NSString *)token Id:(NSString *)Id reason:(NSString *)reason;
//用户评价
-(void)remarkMyRentWithToken:(NSString *)token Id:(NSString *)Id point:(NSNumber *)point remark:(NSString *)remark type:(NSInteger )type;
//常用标签
-(void)fetchUserCommonSkillWithToken:(NSString *)token;
//设置常用标签
-(void)setMyTagWithToken:(NSString *)token tag:(NSArray *)tag;
//确认见面
-(void)comfirmMeetWithToken:(NSString *)token Id:(NSString *)Id type:(NSNumber *)type;
//提出未见面
-(void)submitNoMeetWithToken:(NSString *)token remark:(NSString *)remark img:(NSArray *)img Id:(NSString *)Id;
//提出异议
-(void)submitDissentWithToken:(NSString *)token remark:(NSString *)remark img:(NSArray *)img Id:(NSString *)Id;
@end
