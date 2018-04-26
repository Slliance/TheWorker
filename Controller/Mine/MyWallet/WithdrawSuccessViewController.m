//
//  WithdrawSuccessViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "WithdrawSuccessViewController.h"
#import "MyWalletViewController.h"
#import "WithdrawRecordViewController.h"
@interface WithdrawSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;

@end

@implementation WithdrawSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnBack.layer.masksToBounds = YES;
    self.btnBack.layer.cornerRadius = 4.f;
    [self.btnBack.layer setBorderWidth:1];
    [self.btnBack.layer setBorderColor:[UIColor colorWithHexString:@"6398f1"].CGColor];
    self.btnCheck.layer.masksToBounds = YES;
    self.btnCheck.layer.cornerRadius = 4.f;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

- (IBAction)backToWallet:(id)sender {
    MyWalletViewController *vc = [[MyWalletViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)checkRecord:(id)sender {

    WithdrawRecordViewController *vc = [[WithdrawRecordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
