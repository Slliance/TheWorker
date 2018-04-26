//
//  ServiceViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/21.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ServiceViewController.h"
#import "RentPersonViewModel.h"
#import <NIMSDK/NIMSDK.h>
#import "NTESSessionViewController.h"
@interface ServiceViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnAddFriend;
@property (weak, nonatomic) IBOutlet UILabel *labelPhoneNum;
@property (weak, nonatomic) IBOutlet UILabel *labelWechat;
@property (weak, nonatomic) IBOutlet UILabel *labelQQ;
@property (weak, nonatomic) IBOutlet UILabel *labelStoreId;

@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelQQ.text = [NSString stringWithFormat:@"%@",self.storeModel.qq];
    self.labelWechat.text = [NSString stringWithFormat:@"%@",self.storeModel.wechat];
    self.labelStoreId.text = [NSString stringWithFormat:@"%@",self.storeModel.user_num];
    self.labelPhoneNum.text = [NSString stringWithFormat:@"%@",self.storeModel.mobile];
    if ([self.storeModel.is_friend integerValue] == 1) {
        self.btnAddFriend.selected = YES;
    }
    [self.btnAddFriend.layer setBorderColor:[UIColor colorWithHexString:@"6398f1"].CGColor];
    [self.btnAddFriend.layer setBorderWidth:1];
    [self.btnAddFriend.layer setMasksToBounds:YES];
    [self.btnAddFriend.layer setCornerRadius:4.f];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)telAction:(id)sender {
    if (self.labelPhoneNum.text.length > 0) {
            
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:self.labelPhoneNum.text
                                                                          preferredStyle:UIAlertControllerStyleAlert ];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",self.labelPhoneNum.text];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        [alertController addAction:OKAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

- (IBAction)addAction:(id)sender {
    if (![self isLogin]) {
        [self skiptoLogin];
        return;
    }
    if (self.storeModel.user_mobile.length == 11) {
        NIMSession *session = [NIMSession session:[NSString stringWithFormat:@"%@",self.storeModel.user_mobile] type:NIMSessionTypeP2P];
        NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
        [self.navigationController pushViewController:vc animated:YES];
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
