//
//  LoginViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/9.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"

@interface LoginViewController : HYBaseViewController
@property (nonatomic ,assign) NSInteger loginType; // loginType==1 vc 返回上一级 loginType== 2 vc 返回根视图
@end
