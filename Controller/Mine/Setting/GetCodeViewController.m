//
//  GetCodeViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//
//修改手机号验证邮箱
#import "GetCodeViewController.h"
#import "ChangePhoneNumViewController.h"
#import "UserModel.h"
#import "StartViewModel.h"
#import "ChangeMobileViewModel.h"
@interface GetCodeViewController (){
    NSInteger secondsCountDown;
}
@property (nonatomic,retain) NSTimer *countDownTimer;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;
@property (weak, nonatomic) IBOutlet UIButton *btnNextStep;
@property (nonatomic,retain) UserModel *userModel;

@end

@implementation GetCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    secondsCountDown = 59;
    self.btnGetCode.layer.masksToBounds = YES;
    self.btnGetCode.layer.cornerRadius = 4.f;
    [self.btnGetCode.layer setBorderWidth:1];
    [self.btnGetCode.layer setBorderColor:[UIColor colorWithHexString:@"6398f1"].CGColor];
    self.btnNextStep.layer.masksToBounds = YES;
    self.btnNextStep.layer.cornerRadius = 4.f;
    NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    self.userModel = [[UserModel alloc]initWithDict:userinfo];
    self.labelEmail.text = self.userModel.email;
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.txtCode resignFirstResponder];
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)nextStep:(id)sender {
    if (self.txtCode.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入验证码"];
        return;
    }
    ChangeMobileViewModel *viewModel = [[ChangeMobileViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        ChangePhoneNumViewController *vc = [[ChangePhoneNumViewController alloc]init];
    vc.emailCode = self.txtCode.text;
        [self.navigationController pushViewController:vc animated:YES];

    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel changeMobileWithStep:@"1" mobile:self.labelEmail.text emailCode:self.txtCode.text mobileCode:nil token:self.userModel.token];
}
- (IBAction)getCodeAction:(id)sender {
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
        [viewModel fetchEmailVerificationCode:self.labelEmail.text type:@"2" token:[self getToken]];
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
