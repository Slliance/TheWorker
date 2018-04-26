//
//  MyServiceViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/5.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "MyServiceViewController.h"
#import "BaseDataViewModel.h"
#import "ServiceModel.h"
@interface MyServiceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelWeibo;
@property (weak, nonatomic) IBOutlet UILabel *labelWechat;
@property (weak, nonatomic) IBOutlet UILabel *labelQQ;

@end

@implementation MyServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BaseDataViewModel *viewModel = [[BaseDataViewModel alloc] init];
    [viewModel setBlockWithReturnBlock:^(id returnValue) {
        ServiceModel *model = returnValue;
        self.labelQQ.text = [NSString stringWithFormat:@"%@",model.qq];
        self.labelWeibo.text = model.wechat;
        self.labelWechat.text = model.weibo;
    } WithErrorBlock:^(id errorCode) {
        [self showJGProgressWithMsg:errorCode];
    }];
    [viewModel fetchMyServiceWithToken:[self getToken]];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
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
