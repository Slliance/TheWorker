//
//  HYNotification.h
//  zhongchuan
//
//  Created by yanghao on 9/7/16.
//  Copyright © 2016 huying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYNotification : NSObject
+ (void)removeAllNotification:(id)target;

//登录成功通知
#define LoginSuccessNotification @"LoginSuccessNotification"
+(void)addLoginNotification:(id)target action:(SEL)action;
+(void)postLoginNotification:(NSDictionary *)userInfo;

//登出成功通知
#define LoginOutSuccessNotification @"LoginOutSuccessNotification"
+(void)addLogOutNotification:(id)target action:(SEL)action;
+(void)postLogOutNotification:(NSDictionary *)userInfo;

//登录过期通知
#define LoginDateNotification   @"LoginDateNotification"
+(void)addLoginDateNotification:(id)target action:(SEL)action;
+(void)postLoginDateNOtification:(NSDictionary *)userInfo;

//评价订单页面，关闭键盘通知
#define OrderCommentCloseKeyboardNotification   @"OrderCommentCloseKeyboardNotification"
+(void)addOrderCommentCloseKeyboardNotification:(id)target action:(SEL)action;
+(void)postOrderCommentCloseKeyboardNotification:(NSDictionary *)userInfo;
//销毁定时器
#define DestroyTimerNotification @"DestroyTimerNotification"
+(void)addDestoryTimerNotification:(id)target action:(SEL)action;
+(void)postDestoryNotification:(NSDictionary *)userInfo;

//支付宝支付结果
#define AliPayResultNotification @"AliPayResultNotification"
+(void)addAliPayResultNotification:(id)target action:(SEL)action;
+(void)postAliPayResultNotification:(NSDictionary *)userInfo;

//微信支付结果
#define WeixinPayResultNotification @"WeixinPayResultNotification"
+(void)addWeixinPayResultNotification:(id)target action:(SEL)action;
+(void)postWeixinPayResultNotification:(NSDictionary *)userInfo;

//消息数量更新通知
#define MsgCountUpdateNotification @"MsgCountUpdateNotification"
+(void)addMsgCountUpdateNotification:(id)target action:(SEL)action;
+(void)postMsgCountUpdateNotification:(NSDictionary *)userInfo;

//新朋友消息数量更新通知
#define NewFrientCountUpdateNotification @"NewFrientCountUpdateNotification"
+(void)addNewFrientCountUpdateNotification:(id)target action:(SEL)action;
+(void)postNewFrientCountUpdateNotification:(NSDictionary *)userInfo;

//删除好友通知
#define DelFriendNotification @"DelFriendNotification"
+(void)addDelFriendNotification:(id)target action:(SEL)action;
+(void)postDelFriendNotification:(NSDictionary *)userInfo;
@end
