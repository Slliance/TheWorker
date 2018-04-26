//
//  LoginViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/9.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPwdViewController.h"
#import "StartViewModel.h"
#import <NIMSDK/NIMSDK.h>
#import "UserModel.h"
#import <UMSocialCore/UMSocialCore.h>
#import "JPUSHService.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *oneBgView;
@property (weak, nonatomic) IBOutlet UIView *twoBgView;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIScrollView *loginScrollView;
@property (nonatomic, copy) NSString *pushCode;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.oneBgView.layer.masksToBounds = YES;
    self.oneBgView.layer.cornerRadius = 22.f;
//    self.twoBgView.layer.masksToBounds = YES;
    self.twoBgView.layer.cornerRadius = 22.f;
    self.btnLogin.layer.masksToBounds = YES;
    self.btnLogin.layer.cornerRadius = 22.f;
    [self setTextFieldLeftView:self.txtPhoneNum :@"icon_phone_number":30];
    [self setTextFieldLeftView:self.txtPwd :@"icon_password" :30];
    self.oneBgView.layer.shadowColor = [UIColor colorWithHexString:@"a4c1f1"].CGColor;
    self.oneBgView.layer.shadowOpacity = 0.5f;
    self.oneBgView.layer.shadowRadius = 4.f;
    self.oneBgView.layer.shadowOffset = CGSizeMake(0,4);
    self.twoBgView.layer.shadowColor = [UIColor colorWithHexString:@"a4c1f1"].CGColor;
    self.twoBgView.layer.shadowOpacity = 0.5f;
    self.twoBgView.layer.shadowRadius = 4.f;
    self.twoBgView.layer.shadowOffset = CGSizeMake(0,4);
    self.loginScrollView.contentSize = CGSizeMake(ScreenWidth, 645);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.pushCode = @"";
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
        self.pushCode = registrationID;
    }];

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
//    [self backBtnAction:sender];
    if (self.loginType == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
- (IBAction)isBtnPwdSecurity:(UIButton *)sender {
    // 前提:在xib中设置按钮的默认与选中状态的背景图
    // 切换按钮的状态
    sender.selected = !sender.selected;
    
    if (sender.selected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.txtPwd.text;
        self.txtPwd.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.txtPwd.secureTextEntry = NO;
        self.txtPwd.text = tempPwdStr;
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.txtPwd.text;
        self.txtPwd.text = @"";
        self.txtPwd.secureTextEntry = YES;
        self.txtPwd.text = tempPwdStr;
    }
}

- (IBAction)loginAction:(id)sender {
    if (self.txtPhoneNum.text.length == 0 ) {
        [self showJGProgressWithMsg:@"请输入手机号码"];
        return;
    }
    if (self.txtPwd.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入密码"];
        return;
    }
    StartViewModel *viewModel = [[StartViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self showJGProgressWithMsg:@"登录成功"];
        [self dissJGProgressLoadingWithTag:200];
        
        //登录网易云信
        UserModel *userModel = (UserModel *)returnValue;
        NSString *account = [NSString stringWithFormat:@"%@",userModel.mobile];
        NSString *token   = userModel.im_token;
        [[[NIMSDK sharedSDK] loginManager] login:account
                                           token:token
                                      completion:^(NSError *error) {
                                          [HYNotification postLoginNotification:nil];

                                          
                                          
                                      }];
        
//        if (self.loginType == 1) {
//            [HYNotification postLoginNotification:nil];
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }else{
            [self backAction:nil];
//        }
        
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
        [self dissJGProgressLoadingWithTag:200];
    }];
    [viewModel loginWithMobile:self.txtPhoneNum.text
                      password:[self.txtPwd.text MD5Digest]
                      pushCode:self.pushCode
                 loginWithType:@(0)
                       thirdId:@""
     ];

    [self showJGProgressLoadingWithTag:200];
}
- (IBAction)skipToRegister:(id)sender {
    RegisterViewController *vc = [[RegisterViewController alloc]init];
    vc.type = 0;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)forgetPwdAction:(id)sender {
    ForgetPwdViewController *vc = [[ForgetPwdViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)loginByQQ:(id)sender {
    [self loginWithThird:UMSocialPlatformType_QQ];
}
- (IBAction)loginByWechat:(id)sender {
    [self loginWithThird:UMSocialPlatformType_WechatSession];
}
- (IBAction)loginByWeibo:(id)sender {
    [self loginWithThird:UMSocialPlatformType_Sina];
}


- (void)loginWithThird:(UMSocialPlatformType)platFromType
{
    
    __weak typeof (self)weakSelf = self;
    if (platFromType == UMSocialPlatformType_Sina) {
        if (![[UMSocialManager defaultManager] isInstall:platFromType]) {
            [self showJGProgressWithMsg:@"未安装新浪客户端"];
            return;
        }
        
    }
    if (platFromType == UMSocialPlatformType_QQ) {
        if (![[UMSocialManager defaultManager] isInstall:platFromType]) {
            [self showJGProgressWithMsg:@"未安装QQ客户端"];
            return;
        }
        
    }
    if (platFromType == UMSocialPlatformType_WechatSession) {
        if (![[UMSocialManager defaultManager] isInstall:platFromType]) {
            [self showJGProgressWithMsg:@"未安装微信客户端"];
            return;
        }
        
    }
    
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platFromType currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            if (error.code == UMSocialPlatformErrorType_Cancel ) {
                [weakSelf showJGProgressWithMsg:@"取消操作"];
            }
            else{
                [weakSelf showJGProgressWithMsg:error.debugDescription];
            }
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            int login_type = 0;
            NSString *uuid = @"";
            switch (platFromType) {
                case UMSocialPlatformType_Sina:
                    login_type = 3;
                    uuid = resp.uid;
                    break;
                case UMSocialPlatformType_WechatSession:
                    login_type = 2;
                    uuid = resp.openid;
                    break;
                case UMSocialPlatformType_QQ:
                    login_type = 1;
                    uuid = resp.uid;
                    break;
                default:
                    break;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                StartViewModel *viewModel = [[StartViewModel alloc]init];
                [viewModel setBlockWithReturnBlock:^(id returnValue) {
                    if ([returnValue isEqual:@"700"]) {
                        RegisterViewController *vc = [[RegisterViewController alloc]init];
                        vc.type = login_type;
                        vc.uuid = uuid;
                        [self.navigationController pushViewController:vc animated:YES];

                    }
                    else{
                        [self showJGProgressWithMsg:@"登录成功"];

                        //登录网易云信
                        UserModel *userModel = (UserModel *)returnValue;
                        NSString *account = [NSString stringWithFormat:@"%@",userModel.mobile];
                        NSString *token   = userModel.im_token;
                        [[[NIMSDK sharedSDK] loginManager] login:account
                                                           token:token
                                                      completion:^(NSError *error) {}];
                        [self backAction:nil];
                    }
                    [self dissJGProgressLoadingWithTag:200];
                    
                    
                } WithErrorBlock:^(id errorCode) {
                    [self showJGProgressWithMsg:errorCode];
                    [self dissJGProgressLoadingWithTag:200];
                }];
                [viewModel loginWithMobile:@""
                                  password:@""
                                  pushCode:weakSelf.pushCode
                             loginWithType:@(login_type)
                                   thirdId:uuid
             
                 ];
                
                [self showJGProgressLoadingWithTag:200];
                
            });
        }
    }];
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if(self.txtPhoneNum.text.length > 10) {
//        return NO;
//    }
    return YES;
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
