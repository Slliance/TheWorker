//
//  BindingMailBoxViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BindingMailBoxViewController.h"
#import "BindingSuccessViewController.h"
#import "StartViewModel.h"
#import "BindingMailBoxViewModel.h"
#import "UserModel.h"
@interface BindingMailBoxViewController (){
    NSInteger secondsCountDown;
}
@property (nonatomic,retain) NSTimer *countDownTimer;
@property (weak, nonatomic) IBOutlet UITextField *txtMailBox;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;
@property (weak, nonatomic) IBOutlet UIButton *btnBinding;

@end

@implementation BindingMailBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    secondsCountDown = 59;
    self.btnGetCode.layer.masksToBounds = YES;
    self.btnGetCode.layer.cornerRadius = 4.f;
    [self.btnGetCode.layer setBorderWidth:1];
    [self.btnGetCode.layer setBorderColor:[UIColor colorWithHexString:@"6398f1"].CGColor];
    self.btnBinding.layer.masksToBounds = YES;
    self.btnBinding.layer.cornerRadius = 4.f;
    UIImageView *LeftViewNum = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_phone_number2"]];
    //图片的显示模式
    LeftViewNum.contentMode= UIViewContentModeCenter;
    //图片的位置和大小
    LeftViewNum.frame= CGRectMake(0,0,20,30);
    //左视图默认是不显示的 设置为始终显示
    self.txtMailBox.leftViewMode= UITextFieldViewModeAlways;
    self.txtMailBox.leftView= LeftViewNum;
    
    UIImageView *LeftViewCode = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_verification_code"]];
    //图片的显示模式
    LeftViewCode.contentMode= UIViewContentModeCenter;
    //图片的位置和大小
    LeftViewCode.frame= CGRectMake(0,0,20,30);
    //左视图默认是不显示的 设置为始终显示
    self.txtCode.leftViewMode= UITextFieldViewModeAlways;
    self.txtCode.leftView= LeftViewCode;

    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.txtMailBox resignFirstResponder];
    [self.txtCode resignFirstResponder];
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)getCodeAction:(id)sender {
        StartViewModel *viewModel = [[StartViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            [self showJGProgressWithMsg:@"发送成功"];
    self.btnGetCode.enabled = NO;
    [self.btnGetCode setTitle:@"重新获取59" forState:UIControlStateDisabled];
    [self.btnGetCode.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
    
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel fetchEmailVerificationCode:self.txtMailBox.text type:@"1" token:[self getToken]];
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
- (IBAction)bindingsMailBox:(id)sender {
    if (self.txtMailBox.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入邮箱"];
        return;
    }
    if (self.txtCode.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入验证码"];
        return;
    }
    NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    UserModel *userModel = [[UserModel alloc]initWithDict:userinfo];
    BindingMailBoxViewModel *viewModel = [[BindingMailBoxViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        BindingSuccessViewController *vc = [[BindingSuccessViewController alloc]init];
        vc.emailStr = self.txtMailBox.text;
        [self.navigationController pushViewController:vc animated:YES];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel bindingMailBoxWithStep:@"2" email:self.txtMailBox.text   emailCode:self.txtCode.text mobileCode:self.phoneCode token:userModel.token];

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
