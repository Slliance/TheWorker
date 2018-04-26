//
//  HYNotification.m
//  zhongchuan
//
//  Created by yanghao on 9/7/16.
//  Copyright © 2016 huying. All rights reserved.
//

#import "HYNotification.h"

@implementation HYNotification
+ (void)removeAllNotification:(id)target
{
    [[NSNotificationCenter defaultCenter] removeObserver:target];
}

//登录成功
+(void)addLoginNotification:(id)target action:(SEL)action{
    [[NSNotificationCenter defaultCenter] addObserver:target
                                             selector:action
                                                 name:LoginSuccessNotification
                                               object:nil];
    

}

+(void)postLoginNotification:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter]postNotificationName:LoginSuccessNotification object:nil userInfo:userInfo];
}

//登出成功
+(void)addLogOutNotification:(id)target action:(SEL)action{
    [[NSNotificationCenter defaultCenter] addObserver:target
                                             selector:action
                                                 name:LoginOutSuccessNotification
                                               object:nil];
    
    
}

+(void)postLogOutNotification:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter]postNotificationName:LoginOutSuccessNotification object:nil userInfo:userInfo];
}

//登录过期通知
+(void)addLoginDateNotification:(id)target action:(SEL)action{
    [[NSNotificationCenter defaultCenter] addObserver:target
                                             selector:action name:LoginDateNotification object:nil];
}

+(void)postLoginDateNOtification:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginDateNotification object:nil userInfo:userInfo];
}
//评价订单页面，关闭键盘通知
+(void)addOrderCommentCloseKeyboardNotification:(id)target action:(SEL)action{
    [[NSNotificationCenter defaultCenter] addObserver:target
                                             selector:action name:OrderCommentCloseKeyboardNotification object:nil];
}

+(void)postOrderCommentCloseKeyboardNotification:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:OrderCommentCloseKeyboardNotification object:nil userInfo:userInfo];
}

//销毁定时器
+(void)addDestoryTimerNotification:(id)target action:(SEL)action{
    [[NSNotificationCenter defaultCenter] addObserver:target
                                             selector:action name:DestroyTimerNotification object:nil];
}
+(void)postDestoryNotification:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:DestroyTimerNotification object:nil userInfo:userInfo];
}

//支付宝支付结果
+(void)addAliPayResultNotification:(id)target action:(SEL)action{
    [[NSNotificationCenter defaultCenter] addObserver:target
                                                                                                              selector:action
                                                                                                                  name:AliPayResultNotification
                                                                                                                object:nil];
    
    
}

+(void)postAliPayResultNotification:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:AliPayResultNotification object:nil userInfo:userInfo];
}

//消息数量更新通知

+(void)addMsgCountUpdateNotification:(id)target action:(SEL)action{
    [[NSNotificationCenter defaultCenter] addObserver:target
                                             selector:action
                                                 name:MsgCountUpdateNotification
                                               object:nil];
    

}
+(void)postMsgCountUpdateNotification:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:MsgCountUpdateNotification object:nil userInfo:userInfo];

}

//新朋友消息数量更新通知

+(void)addNewFrientCountUpdateNotification:(id)target action:(SEL)action{
    [[NSNotificationCenter defaultCenter] addObserver:target
                                             selector:action
                                                 name:NewFrientCountUpdateNotification
                                               object:nil];
    
    
}
+(void)postNewFrientCountUpdateNotification:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:NewFrientCountUpdateNotification object:nil userInfo:userInfo];
    
}
//删除好友通知

+(void)addDelFriendNotification:(id)target action:(SEL)action{
    [[NSNotificationCenter defaultCenter] addObserver:target
                                             selector:action
                                                 name:DelFriendNotification
                                               object:nil];
    
    
}
+(void)postDelFriendNotification:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:DelFriendNotification object:nil userInfo:userInfo];
    
}


//微信支付结果
+(void)addWeixinPayResultNotification:(id)target action:(SEL)action{    [[NSNotificationCenter defaultCenter] addObserver:target
                                                                                                                 selector:action
                                                                                                                     name:WeixinPayResultNotification
                                                                                                                   object:nil];
}

+(void)postWeixinPayResultNotification:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:WeixinPayResultNotification object:nil userInfo:userInfo];
}
@end
