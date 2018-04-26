//
//  BindingsEmailViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BindingsEmailViewController.h"
#import "GetPhoneCodeViewController.h"
#import "UserModel.h"
@interface BindingsEmailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNum;
@property (weak, nonatomic) IBOutlet UIButton *btnBinding;

@end

@implementation BindingsEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    UserModel *userModel = [[UserModel alloc]initWithDict:userinfo];
    self.btnBinding.layer.masksToBounds = YES;
    self.btnBinding.layer.cornerRadius = 4.f;
    self.labelPhoneNum.text = [NSString stringWithFormat:@"当前绑定手机号：%@",userModel.mobile];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)skipToBinding:(id)sender {
    NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    UserModel *userModel = [[UserModel alloc]initWithDict:userinfo];
    GetPhoneCodeViewController *vc = [[GetPhoneCodeViewController alloc]init];
    vc.mobileStr = [NSString stringWithFormat:@"%@",userModel.mobile];
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
