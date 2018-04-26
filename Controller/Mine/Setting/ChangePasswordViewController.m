//
//  ChangePasswordViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UpdatePasswordViewModel.h"
#import "UserModel.h"
#import "LoginViewController.h"
#import "CustomTool.h"
#import "StartViewModel.h"
@interface ChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtNowPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPwdAgain;
@property (weak, nonatomic) IBOutlet UIButton *btnChange;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnChange.layer.masksToBounds = YES;
    self.btnChange.layer.cornerRadius = 4.f;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)changeAction:(id)sender {
    if (self.txtNowPwd.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入原密码"];
        return;
    }
    if (self.txtNewPwd.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入新密码"];
        return;
    }
    if (![CustomTool isValidtePassword:self.txtNewPwd.text]) {
        [self showJGProgressWithMsg:@"请输入6-20位字母数字组合的新密码"];
        return;
    }
    if (![self.txtNewPwd.text isEqualToString:self.txtNewPwdAgain.text]) {
           [self showJGProgressWithMsg:@"两次输入的密码不一致"];
        return;
    }
    NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    UserModel *userModel = [[UserModel alloc] initWithDict:userinfo];
    UpdatePasswordViewModel *viewModel = [[UpdatePasswordViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        StartViewModel *viewModel = [[StartViewModel alloc] init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [UserDefaults clearUserDefaultWithKey:user_info];
            [UserDefaults clearUserDefaultWithKey:im_token_key];
            [HYNotification postLogOutNotification:nil];
            [self showJGProgressWithMsg:@"密码修改成功，请重新登陆"];
            [self skiptoLoginAndBackRootVC];
            
        } WithErrorBlock:^(id errorCode) {
        }];
        [viewModel logoutWithId:userModel.Id];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel updatePasswordWithToken:userModel.token oldPassword:[self.txtNowPwd.text MD5Digest] newPassword:[self.txtNewPwd.text MD5Digest] rePassword:[self.txtNewPwdAgain.text MD5Digest]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
