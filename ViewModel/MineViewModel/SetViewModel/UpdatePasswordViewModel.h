//
//  UpdatePasswordViewModel.h
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/7.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BaseViewModel.h"

@interface UpdatePasswordViewModel : BaseViewModel
-(void)updatePasswordWithToken:(NSString *)token oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword rePassword:(NSString *)rePassword;
@end
