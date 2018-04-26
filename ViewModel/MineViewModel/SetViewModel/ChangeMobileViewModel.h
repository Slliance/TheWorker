//
//  ChangeMobileViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/7.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface ChangeMobileViewModel : BaseViewModel
-(void)changeMobileWithStep:(NSString *)step mobile:(NSString *)mobile emailCode:(NSString *)emailCode mobileCode:(NSString *)mobileCode token:(NSString *)token;

@end
