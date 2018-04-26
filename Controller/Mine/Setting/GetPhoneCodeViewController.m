//
//  GetPhoneCodeViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//
//绑定邮箱验证手机号
#import "GetPhoneCodeViewController.h"
#import "BindingMailBoxViewController.h"
#import "StartViewModel.h"
#import "BindingMailBoxViewModel.h"
#import "UserModel.h"
@interface GetPhoneCodeViewController (){
    NSInteger secondsCountDown;
}
@property (nonatomic,retain) NSTimer *countDownTimer;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;
@property (weak, nonatomic) IBOutlet UIButton *btnNextStep;

@end

@implementation GetPhoneCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    secondsCountDown = 59;
    self.btnGetCode.layer.masksToBounds = YES;
    self.btnGetCode.layer.cornerRadius = 4.f;
    [self.btnGetCode.layer setBorderWidth:1];
    [self.btnGetCode.layer setBorderColor:[UIColor colorWithHexString:@"6398f1"].CGColor];
    self.btnNextStep.layer.masksToBounds = YES;
    self.btnNextStep.layer.cornerRadius = 4.f;
    self.labelPhoneNum.text = self.mobileStr;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.txtCode resignFirstResponder];
}
- (IBAction)getCode:(id)sender {
    
    StartViewModel *viewModel = [[StartViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self showJGProgressWithMsg:@"发送成功"];
        [self dissJGProgressLoadingWithTag:200];
        self.btnGetCode.enabled = NO;
        [self.btnGetCode setTitle:@"重新获取59" forState:UIControlStateDisabled];
        [self.btnGetCode.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
        
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
        [self dissJGProgressLoadingWithTag:200];
    }];
    [viewModel fetchMessageVerificationCode:self.mobileStr type:@"4"];
    [self showJGProgressLoadingWithTag:200];
}
/**
 *  倒计时调用方法
 */
-(void)startTimer{
    [self.btnGetCode setTitle:[NSString stringWithFormat:@"重新获取%ld",(long)--secondsCountDown] forState:UIControlStateDisabled];
    [self.btnGetCode.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];
    if (secondsCountDown == -1) {
        secondsCountDown = 59;
        [_countDownTimer invalidate];
        [self.btnGetCode setTitle:@"获取验证码" forState:UIControlStateDisabled];
        [self.btnGetCode.layer setBorderColor:[UIColor colorWithHexString:@"6398f1"].CGColor];
        self.btnGetCode.enabled = YES;
    }
}
- (IBAction)nextStep:(id)sender {
    if (self.txtCode.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入验证码"];
        return;
    }
    
    NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    UserModel *userModel = [[UserModel alloc]initWithDict:userinfo];
    BindingMailBoxViewModel *viewModel = [[BindingMailBoxViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        BindingMailBoxViewController *vc = [[BindingMailBoxViewController alloc]init];
    vc.phoneCode = self.txtCode.text;
        [self.navigationController pushViewController:vc animated:YES];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel bindingMailBoxWithStep:@"1" email:self.labelPhoneNum.text emailCode:nil mobileCode:self.txtCode.text token:userModel.token];
    
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
