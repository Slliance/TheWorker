//
//  ForgetPwdViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/9.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "StartViewModel.h"
@interface ForgetPwdViewController ()<UITextFieldDelegate>{
    NSInteger secondsCountDown;
}
@property (nonatomic,retain) NSTimer *countDownTimer;
@property (weak, nonatomic) IBOutlet UIButton *btnCode;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPwd;
@property (weak, nonatomic) IBOutlet UILabel *labelAlert;
@property (weak, nonatomic) IBOutlet UIButton *btnSet;

@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    secondsCountDown = 59;
    [self setTextFieldLeftView:self.txtPhoneNum :@"icon_phone_number2" :30];
    [self setTextFieldLeftView:self.txtPassword :@"icon_password2" :30];
    [self setTextFieldLeftView:self.txtCode :@"icon_verification_code" :30];
    [self setTextFieldLeftView:self.txtNewPwd :@"icon_password2" :30];
    self.btnSet.layer.masksToBounds = YES;
    self.btnSet.layer.cornerRadius = 4.f;
    [self.btnCode.layer setMasksToBounds:YES];
    [self.btnCode.layer setBorderColor:[UIColor colorWithHexString:@"699cf1"].CGColor];
    [self.btnCode.layer setBorderWidth:1];
    [self.btnCode.layer setCornerRadius:4.f];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)getCodeAction:(id)sender {
    if (self.txtPhoneNum.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入手机号码"];
        return;
    }
    if (self.txtPhoneNum.text.length != 11) {
        [self showJGProgressWithMsg:@"请输入11位手机号码"];
        return;
    }
    StartViewModel *viewModel = [[StartViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self showJGProgressWithMsg:@"发送成功"];
        [self dissJGProgressLoadingWithTag:200];
        self.btnCode.enabled = NO;
        [self.btnCode setTitle:@"重新获取59" forState:UIControlStateDisabled];
    [self.btnCode.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];

        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
        
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
        [self dissJGProgressLoadingWithTag:200];
    }];
    [viewModel fetchMessageVerificationCode:self.txtPhoneNum.text type:@"2"];
    [self showJGProgressLoadingWithTag:200];
}
/**
 *  倒计时调用方法
 */
-(void)startTimer{
    [self.btnCode setTitle:[NSString stringWithFormat:@"重新获取%ld",(long)--secondsCountDown] forState:UIControlStateDisabled];
    [self.btnCode.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];

    if (secondsCountDown == -1) {
        secondsCountDown = 59;
        [_countDownTimer invalidate];
        [self.btnCode setTitle:@"获取验证码" forState:UIControlStateDisabled];
        [self.btnCode.layer setBorderColor:[UIColor colorWithHexString:@"6398f1"].CGColor];
        self.btnCode.enabled = YES;
    }
}

- (IBAction)setNewPwdAction:(id)sender{

    if (self.txtPhoneNum.text.length != 11) {
        [self showJGProgressWithMsg:@"请输入11位手机号码"];
        return;
    }
    if (self.txtCode.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入验证码"];
        return;
    }
    if (![CustomTool isValidtePassword:self.txtPassword.text]) {
        [self showJGProgressWithMsg:@"请输入6-20位字母数字组合的新密码"];
        return;
    }
    if (![self.txtPassword.text isEqualToString:self.txtNewPwd.text]) {
        [self showJGProgressWithMsg:@"两次输入的密码不一致"];
        return;
    }
    StartViewModel *viewModel = [[StartViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self backBtnAction:nil];
        [self showJGProgressWithMsg:@"密码修改成功"];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel forgetPasswordWithMobile:self.txtPhoneNum.text
                               password:[self.txtPassword.text MD5Digest]
                             rePassword:[self.txtNewPwd.text MD5Digest]
                                   code:self.txtCode.text];
}
- (IBAction)btnPwdIsSecurity:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.txtPassword.text;
        self.txtPassword.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.txtPassword.secureTextEntry = NO;
        self.txtPassword.text = tempPwdStr;
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.txtPassword.text;
        self.txtPassword.text = @"";
        self.txtPassword.secureTextEntry = YES;
        self.txtPassword.text = tempPwdStr;
    }

}
- (IBAction)btnNewPwdIsSecurity:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.txtNewPwd.text;
        self.txtNewPwd.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.txtNewPwd.secureTextEntry = NO;
        self.txtNewPwd.text = tempPwdStr;
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.txtNewPwd.text;
        self.txtNewPwd.text = @"";
        self.txtNewPwd.secureTextEntry = YES;
        self.txtNewPwd.text = tempPwdStr;
    }

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
