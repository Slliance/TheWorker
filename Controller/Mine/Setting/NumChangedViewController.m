//
//  NumChangedViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "NumChangedViewController.h"
#import "LoginViewController.h"
@interface NumChangedViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNum;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@end

@implementation NumChangedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnLogin.layer.masksToBounds = YES;
    self.btnLogin.layer.cornerRadius = 4.f;
    [self.btnLogin.layer setBorderWidth:1];
    [self.btnLogin.layer setBorderColor:[UIColor colorWithHexString:@"6398f1"].CGColor];
    self.labelPhoneNum.text = self.mobileStr;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)loginAgain:(id)sender {
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.loginType = 2;
    [self.navigationController pushViewController:vc animated:YES];
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
