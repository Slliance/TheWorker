//
//  RegisterViewController.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/9.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "HYBaseViewController.h"

@interface RegisterViewController : HYBaseViewController
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, assign) NSInteger type;//0直接注册 1qq 2微信 3微博
@end
