//
//  PhoneAndEmailViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "PhoneAndEmailViewController.h"
#import "GetCodeViewController.h"
#import "UserModel.h"
@interface PhoneAndEmailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNum;
@property (weak, nonatomic) IBOutlet UILabel *labelEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnChange;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageType;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation PhoneAndEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    UserModel *userModel = [[UserModel alloc]initWithDict:userinfo];
    self.btnChange.layer.masksToBounds = YES;
    self.btnChange.layer.cornerRadius = 4.f;
    if (self.phoneOrMailbox == YES) {
        self.labelTitle.text = @"更换手机号";
        CGRect rect = self.bgView.frame;
        rect.size.height = 302;
        self.bgView.frame = rect;
    }else{
        self.labelTitle.text = @"绑定邮箱";
        CGRect rect = self.bgView.frame;
        rect.size.height = 238;
        self.bgView.frame = rect;
        self.btnChange.hidden = YES;
    }
    self.labelPhoneNum.text = [NSString stringWithFormat:@"当前绑定手机号：%@",userModel.mobile];
    self.labelEmail.text = [NSString stringWithFormat:@"当前绑定邮箱：%@",userModel.email];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)changePhoneNum:(id)sender {
    NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
    UserModel *userModel = [[UserModel alloc]initWithDict:userinfo];
    if (userModel.email.length > 0) {
        GetCodeViewController *vc = [[GetCodeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self showJGProgressWithMsg:@"请先绑定邮箱"];
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
