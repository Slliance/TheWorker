//
//  BankCardDetailViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/23.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "BankCardDetailViewController.h"
#import "WalletViewModel.h"
#import "BankModel.h"
@interface BankCardDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelCardNo;
@property (weak, nonatomic) IBOutlet UILabel *labelBankName;
@property (weak, nonatomic) IBOutlet UILabel *labelBindingTime;

@end

@implementation BankCardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    WalletViewModel *viewModel = [[WalletViewModel alloc]init];
//    [viewModel setBlockWithReturnBlock:^(id returnValue) {
//        BankModel *model = returnValue;
        self.labelCardNo.text = [NSString stringWithFormat:@"%@",self.bankModel.card];
        self.labelBankName.text = self.bankModel.name;
        self.labelUserName.text = self.bankModel.real_name;
        self.labelBindingTime.text = self.bankModel.createtime;
//    } WithErrorBlock:^(id errorCode) {
//        [self showJGProgressWithMsg:errorCode];
//    }];
//    [viewModel fetchBankCardDetailWithId:self.cardId token:[self getToken]];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

- (IBAction)deleteAction:(id)sender {
    WalletViewModel *viewModel = [[WalletViewModel alloc]init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        [self showJGProgressWithMsg:@"删除成功"];
        [self backBtnAction:nil];
        self.deleteReturnBlock();
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel deleteBankCradWithId:self.bankModel.Id token:[self getToken]];
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
