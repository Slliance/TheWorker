//
//  FriendViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/10/20.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface FriendViewModel : BaseViewModel
//处理好友请求
-(void)handleFriendApplyWithToken:(NSString *)token Id:(NSString *)Id type:(NSNumber *)type;
//好友申请列表
-(void)fetchFriendApplyListWithToken:(NSString *)token page:(NSNumber *)page;
//通讯录
-(void)fetchMyFriendListWithToken:(NSString *)token name:(NSString *)name;
//查找用户
-(void)searchUserWithName:(NSString *)name token:(NSString *)token page:(NSNumber *)page;
//删除好友
-(void)deleteFriendWithToken:(NSString *)token Id:(NSString *)Id;
//设置备注
-(void)setRemarkWithToken:(NSString *)token Id:(NSString *)Id remark:(NSString *)remark;
//删除好友申请
-(void)deleteFriendApplyWithToken:(NSString *) token Id:(NSString *)Id;
//通过手机号添加好友
-(void)addFriendWithToken:(NSString *)token mobile:(NSString *)mobile;
//获取用户信息
-(void)fetchFriendInfomationWithToken:(NSString *)token mobile:(NSString *)mobile;
//通过id获取用户信息
-(void)fetchFriendInfomationWithToken:(NSString *)token Id:(NSString *)Id;

@end
