//
//  MyGradeViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/11/6.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface MyGradeViewModel : BaseViewModel
//获取邀请记录
-(void)fetchMyFriendAmount:(NSString *)token page:(NSNumber *)page level:(NSNumber *)level;
//获取我的团队
-(void)fetchMyTeamWithToken:(NSString *)token page:(NSNumber *)page type:(NSNumber *)type;
//根据手机号获取团队成员
-(void)fetchTeamDetailWithToken:(NSString *)token mobile:(NSString *)mobile page:(NSNumber *)page;
@end
