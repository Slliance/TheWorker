//
//  VertificationViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/8.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface VertificationViewModel : BaseViewModel
//提交用户认证信息
-(void)uploadInfomationWith:(NSString *)name authImg:(NSString *)authImg video:(NSString *)video token:(NSString *)token showImg:(NSString *)show_img;
//获取用户认证信息
-(void)fetchUserAuthInfomationWithToken:(NSString *)token;
@end
