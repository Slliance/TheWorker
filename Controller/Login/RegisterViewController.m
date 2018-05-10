//
//  RegisterViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/9.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RegisterViewController.h"
#import "AboutUsWebViewController.h"
#import "StartViewModel.h"
#import "UserModel.h"
#import <NIMSDK/NIMSDK.h>
#import "JPUSHService.h"

@interface RegisterViewController ()<UITextFieldDelegate>{
    NSInteger secondsCountDown;
}
@property (nonatomic,retain) NSTimer *countDownTimer;
@property (weak, nonatomic) IBOutlet UIButton *btnRegisterOrBinding;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnCode;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UILabel *labelProtocol;
@property (weak, nonatomic) IBOutlet UIButton *btnAuthorized;
@property (nonatomic, retain) NSString *pushCode;
@property (weak, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UIView *bindingView;
@property (weak, nonatomic) IBOutlet UITextField *txtBindingMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtBindingCode;
@property (weak, nonatomic) IBOutlet UIButton *btnBindingCode;
@property (weak, nonatomic) IBOutlet UIButton *btnBinding;
@property (nonatomic, assign) NSInteger registerOrBinding;//0注册 1绑定
@property (nonatomic, assign) NSInteger codeType;//0注册 1绑定
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    secondsCountDown = 59;
    self.registerOrBinding = 1;
    if (self.type == 0) {
        self.btnRegisterOrBinding.hidden = YES;
    }else{
        self.btnRegisterOrBinding.hidden = NO;
    }
        self.btnRegister.layer.masksToBounds = YES;
        self.btnRegister.layer.cornerRadius = 20.f;
        [self.btnCode.layer setMasksToBounds:YES];
        [self.btnCode.layer setBorderColor:[UIColor colorWithHexString:@"699cf1"].CGColor];
        [self.btnCode.layer setBorderWidth:1];
        [self.btnCode.layer setCornerRadius:20.f];
    [self setTextFieldLeftView:self.txtPhoneNum :@"register_phone" :40];
    [self setTextFieldLeftView:self.txtPassword :@"register_password" :40];
    [self setTextFieldLeftView:self.txtCode :@"register_verification" :40];
        
        NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc]initWithString:self.labelProtocol.text];
        //    NSRange redRangeTwo = ;
        [noteStr addAttribute:NSForegroundColorAttributeName value:DSColorFromHex(0xFCDC05) range:NSMakeRange(18, 6)];
        [self.labelProtocol setAttributedText:noteStr];
        [self.labelProtocol sizeToFit];
    
        self.btnBinding.layer.cornerRadius = 4.f;
        self.btnBinding.layer.masksToBounds = YES;
        [self.btnBindingCode.layer setBorderColor:[UIColor colorWithHexString:@"699cf1"].CGColor];
        [self.btnBindingCode.layer setBorderWidth:1];
    
    [self setTextFieldLeftView:self.txtBindingMobile :@"icon_phone_number2":30];
    [self setTextFieldLeftView:self.txtBindingCode :@"icon_verification_code":30];
    self.txtPhoneNum.layer.cornerRadius = 20.f;
    self.txtPhoneNum.layer.masksToBounds = YES;
    [self.txtPhoneNum.layer setBorderColor:DSColorFromHex(0xFFFFFF).CGColor];
    [self.txtPhoneNum.layer setBorderWidth:1];
    self.txtPassword.layer.cornerRadius = 20.f;
    self.txtPassword.layer.masksToBounds = YES;
    [self.txtPassword.layer setBorderColor:DSColorFromHex(0xFFFFFF).CGColor];
    [self.txtPassword.layer setBorderWidth:1];
    self.txtCode.layer.cornerRadius = 20.f;
    self.txtCode.layer.masksToBounds = YES;
    [self.txtCode.layer setBorderColor:DSColorFromHex(0xFFFFFF).CGColor];
    [self.txtCode.layer setBorderWidth:1];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = DSColorFromHex(0xFFFFFF);
    //NSAttributedString:带有属性的文字（叫富文本，可以让你的文字丰富多彩）但是这个是不可变的带有属性的文字，创建完成之后就不可以改变了  所以需要可变的
    NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc]initWithString:@"手机号" attributes:attrs];
    self.txtPhoneNum.attributedPlaceholder = placeHolder;
    NSMutableAttributedString *codeplaceHolder = [[NSMutableAttributedString alloc]initWithString:@"验证码" attributes:attrs];
    self.txtCode.attributedPlaceholder = codeplaceHolder;
    NSMutableAttributedString *passplaceHolder = [[NSMutableAttributedString alloc]initWithString:@"密码" attributes:attrs];
    self.txtPassword.attributedPlaceholder = passplaceHolder;
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
        self.pushCode = registrationID;
    }];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
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
//绑定获取验证码
- (IBAction)getBindingCode:(id)sender {
    if (![CustomTool isValidtePhone:self.txtBindingMobile.text]) {
        [self showJGProgressWithMsg:@"请输入手机号码"];
        return;
    }
    self.codeType = 1;
    StartViewModel *viewModel = [[StartViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self showJGProgressWithMsg:@"发送成功"];
        [self dissJGProgressLoadingWithTag:200];
            self.btnBindingCode.enabled = NO;
            [self.btnBindingCode setTitle:@"重新获取59" forState:UIControlStateDisabled];
            [self.btnBindingCode.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];
            _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
        
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
        [self dissJGProgressLoadingWithTag:200];
    }];
    [viewModel fetchMessageVerificationCode:self.txtBindingMobile.text type:@"1"];
    [self showJGProgressLoadingWithTag:200];
    
}


//注册获取验证码
- (IBAction)getCodeAction:(id)sender {
    if (![CustomTool isValidtePhone:self.txtPhoneNum.text]) {
        [self showJGProgressWithMsg:@"请输入手机号码"];
        return;
    }
    self.codeType = 0;
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
    [viewModel fetchMessageVerificationCode:self.txtPhoneNum.text type:@"1"];
    [self showJGProgressLoadingWithTag:200];
}
/**
 *  倒计时调用方法
 */
-(void)startTimer{
    if (self.codeType == 0) {
        [self.btnCode setTitle:[NSString stringWithFormat:@"重新获取%ld",(long)--secondsCountDown] forState:UIControlStateDisabled];
        [self.btnCode.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];
        if (secondsCountDown == -1) {
            secondsCountDown = 59;
            [_countDownTimer invalidate];
            [self.btnCode setTitle:@"获取验证码" forState:UIControlStateDisabled];
            [self.btnCode.layer setBorderColor:[UIColor colorWithHexString:@"6398f1"].CGColor];
            self.btnCode.enabled = YES;
        }
    }else{
        [self.btnBindingCode setTitle:[NSString stringWithFormat:@"重新获取%ld",(long)--secondsCountDown] forState:UIControlStateDisabled];
        [self.btnBindingCode.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];
        if (secondsCountDown == -1) {
            secondsCountDown = 59;
            [_countDownTimer invalidate];
            [self.btnBindingCode setTitle:@"获取验证码" forState:UIControlStateDisabled];
            [self.btnBindingCode.layer setBorderColor:[UIColor colorWithHexString:@"6398f1"].CGColor];
            self.btnBindingCode.enabled = YES;
        }
    }
    
}
- (IBAction)isAuthorized:(id)sender {
    if (self.btnAuthorized.selected == NO) {
        self.btnAuthorized.selected = YES;
    }else{
        self.btnAuthorized.selected = NO;
    }
}
- (IBAction)registerAction:(id)sender {
    if (![CustomTool isValidtePhone:self.txtPhoneNum.text]) {
        [self showJGProgressWithMsg:@"请输入手机号码"];
        return;
    }
    if (self.txtCode.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入验证码"];
        return;
    }
    if (self.txtPassword.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入密码"];
        return;
    }
    if (![CustomTool isValidtePassword:self.txtPassword.text]) {
        [self showJGProgressWithMsg:@"请输入6-20位字母数字组合的新密码"];
        return;
    }
    if (self.btnAuthorized.selected == YES) {
        [self showJGProgressWithMsg:@"您还未同意注册协议"];
        return;
    }
    StartViewModel *viewModel = [[StartViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self showJGProgressWithMsg:@"注册成功"];
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
        [self.navigationController popToRootViewControllerAnimated:YES];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
        [self dissJGProgressLoadingWithTag:200];
    }];
    [viewModel registerWithMobile:self.txtPhoneNum.text
                             code:self.txtCode.text
                         password:[self.txtPassword.text MD5Digest]
                         pushcode:self.pushCode
                             uuid:self.uuid
                             type:self.type
     
     ];
    
    [self showJGProgressLoadingWithTag:200];
}
- (IBAction)changeTypeAction:(id)sender {
    if (self.registerOrBinding == 0) {
        self.titleLabel.text = @"注册";
        self.registerView.hidden = NO;
        self.bindingView.hidden = YES;
        self.registerOrBinding = 1;
        [self.btnRegisterOrBinding setTitle:@"已有账号" forState:UIControlStateNormal];
        
        secondsCountDown = 59;
        [_countDownTimer invalidate];
        [self.btnCode setTitle:@"获取验证码" forState:UIControlStateDisabled];
        [self.btnCode.layer setBorderColor:[UIColor colorWithHexString:@"6398f1"].CGColor];
        self.btnCode.enabled = YES;
        
    }else{
        self.titleLabel.text = @"绑定手机号";
        self.registerView.hidden = YES;
        self.bindingView.hidden = NO;
        self.registerOrBinding = 0;
        [self.btnRegisterOrBinding setTitle:@"注册账号" forState:UIControlStateNormal];
        secondsCountDown = 59;
        [_countDownTimer invalidate];
        [self.btnBindingCode setTitle:@"获取验证码" forState:UIControlStateDisabled];
        [self.btnBindingCode.layer setBorderColor:[UIColor colorWithHexString:@"6398f1"].CGColor];
        self.btnBindingCode.enabled = YES;
    }
    
}

- (IBAction)bindingAction:(id)sender {
    if (![CustomTool isValidtePhone:self.txtBindingMobile.text]) {
        [self showJGProgressWithMsg:@"请输入手机号码"];
        return;
    }
    if (self.txtBindingCode.text.length == 0) {
        [self showJGProgressWithMsg:@"请输入验证码"];
        return;
    }

    StartViewModel *viewModel = [[StartViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self showJGProgressWithMsg:@"绑定成功"];
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
        [self.navigationController popToRootViewControllerAnimated:YES];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
        [self dissJGProgressLoadingWithTag:200];
    }];
    [viewModel registerWithMobile:self.txtBindingMobile.text
                             code:self.txtBindingCode.text
                         password:@""
                         pushcode:self.pushCode
                             uuid:self.uuid
                             type:self.type
     
     ];
    
    [self showJGProgressLoadingWithTag:200];
}


- (IBAction)skipToProtocol:(id)sender {
    AboutUsWebViewController *vc = [[AboutUsWebViewController alloc] init];
    vc.urlStr = @"register";
    vc.titleStr = @"注册协议";
    [self.navigationController pushViewController:vc animated:YES];
//    ProtocolViewController *vc = [[ProtocolViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
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
