//
//  SettingViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "SettingViewController.h"
#import "ChangePasswordViewController.h"
#import "PhoneAndEmailViewController.h"
#import "BindingsEmailViewController.h"
#import "IdentityVerificationViewController.h"
#import "AboutUsViewController.h"
#import "LoginViewController.h"
#import "StartViewModel.h"
#import "UserModel.h"
#import "NotVertificationViewController.h"
#import "VertificateDefeatViewController.h"
#import "VertificateResultViewController.h"
#import "IdentityVerificationViewController.h"
#import "FeedBackViewController.h"
#import "UserViewModel.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic ,retain) UserModel *userModel;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[@[@"修改密码",@"修改绑定手机号码",@"邮箱设置",@"实名认证",@"意见反馈",@"关于我们"],@[@"退出当前登录"]];
    [self.settingTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"setCell"];
    if ([self.settingTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.settingTableView setSeparatorInset:UIEdgeInsetsMake(44, 13, 0, 10)];
        
    }
    self.userModel = [[UserModel alloc] init];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    
        UserViewModel *viewModel = [[UserViewModel alloc]init];
        [viewModel setBlockWithReturnBlock:^(id returnValue) {
            self.userModel = returnValue;
        } WithErrorBlock:^(id errorCode) {
            [self showJGProgressWithMsg:errorCode];
        }];
        [viewModel fetchUserInfomationWithToken:[self getToken]];
}

- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setCell"];
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 1) {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"ff6666"];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}
#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }
    return 37;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                ChangePasswordViewController *vc = [[ChangePasswordViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 1:
            {
                PhoneAndEmailViewController *vc = [[PhoneAndEmailViewController alloc]init];
                vc.phoneOrMailbox = YES;//跳转后为更换手机号
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2:
            {
                UserModel *userModel = [[UserModel alloc] initWithDict:[UserDefaults readUserDefaultObjectValueForKey:user_info]];
                if (userModel.email.length > 0) {
                    PhoneAndEmailViewController *vc = [[PhoneAndEmailViewController alloc]init];
                    vc.phoneOrMailbox = NO;//跳转后为邮箱绑定完成后的界面
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }else{
                    //跳转至绑定邮箱界面
                    BindingsEmailViewController *vc = [[BindingsEmailViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                
            }
            case 3:
            {
             
                if (self.userModel.auth) {
                    [self skipToCetification];
                }else{
                    UserViewModel *viewModel = [[UserViewModel alloc]init];
                    [viewModel setBlockWithReturnBlock:^(id returnValue) {
                        self.userModel = returnValue;
                        [self dissJGProgressLoadingWithTag:200];
                        [self skipToCetification];
                    } WithErrorBlock:^(id errorCode) {
                        [self dissJGProgressLoadingWithTag:200];
                        [self showJGProgressWithMsg:errorCode];
                    }];
                    [viewModel fetchUserInfomationWithToken:[self getToken]];
                    [self showJGProgressLoadingWithTag:200];
                }
                
                
                break;
            }
            case 4:
            {
                FeedBackViewController *vc = [[FeedBackViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 5:
            {
                AboutUsViewController *vc = [[AboutUsViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            default:
                break;
        }
    }else{
        NSDictionary *userinfo = [UserDefaults readUserDefaultObjectValueForKey:user_info];
        UserModel *userModel = [[UserModel alloc]initWithDict:userinfo];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"确定退出登录？"
                                                                          preferredStyle:UIAlertControllerStyleAlert ];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
           

            
            StartViewModel *viewModel = [[StartViewModel alloc]init];
            [viewModel setBlockWithReturnBlock:^(id returnValue) {
                [self dissJGProgressLoadingWithTag:200];
                [[[NIMSDK sharedSDK] loginManager] logout:^(NSError * _Nullable error) {
                    [UserDefaults clearUserDefaultWithKey:user_info];
                    [UserDefaults clearUserDefaultWithKey:im_token_key];
                    [HYNotification postLogOutNotification:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];

            } WithErrorBlock:^(id errorCode) {
                [self showJGProgressWithMsg:errorCode];

            }];
            [viewModel logoutWithId:userModel.Id];
            [self showJGProgressLoadingWithTag:200];
            
        
        }];
        [alertController addAction:OKAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
}
-(void)skipToCetification{
    if ([self.userModel.auth integerValue] == 0) {
        NotVertificationViewController *vc = [[NotVertificationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.userModel.auth integerValue] == 1){
        VertificateResultViewController *vc = [[VertificateResultViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.userModel.auth integerValue] == 2){
        IdentityVerificationViewController *vc = [[IdentityVerificationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        VertificateDefeatViewController *vc = [[VertificateDefeatViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
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
