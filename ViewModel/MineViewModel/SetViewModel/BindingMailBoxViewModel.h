//
//  BindingMailBoxViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/7.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface BindingMailBoxViewModel : BaseViewModel
-(void)bindingMailBoxWithStep:(NSString *)step email:(NSString *)email emailCode:(NSString *)emailCode mobileCode:(NSString *)mobileCode token:(NSString *)token;
@end
