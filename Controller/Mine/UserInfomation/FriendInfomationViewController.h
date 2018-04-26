//
//  FriendInfomationViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/11/8.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"

@interface FriendInfomationViewController : HYBaseViewController
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, assign) NSInteger flag;   //0,好友详情，返回根部刷新页面；1，我的粉丝列表，返回列表刷新页面
@end
