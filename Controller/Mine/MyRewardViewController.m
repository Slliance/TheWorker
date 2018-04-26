//
//  MyRewardViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/5.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyRewardViewController.h"
#import "RewardRecordViewController.h"
#import "WalletViewModel.h"
@interface MyRewardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelScore;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;

@end

@implementation MyRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnRecord.layer.cornerRadius = 4.f;
    self.btnRecord.layer.masksToBounds = YES;
    WalletViewModel *viewModel = [[WalletViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        self.labelScore.text = [NSString stringWithFormat:@"%@",returnValue];
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchMyRewardWithToken:[self getToken]];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}
- (IBAction)checkRecord:(id)sender {
    RewardRecordViewController *vc = [[RewardRecordViewController alloc]init];
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
