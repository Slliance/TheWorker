//
//  OrderSuccessViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "OrderSuccessViewController.h"
#import "RentSelfViewController.h"
#import "HandInHandSViewController.h"
#import "MyRentViewController.h"
#import "MyRentPersonViewController.h"
@interface OrderSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnOrder;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;

@end

@implementation OrderSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnOrder.layer.masksToBounds = YES;
    self.btnOrder.layer.cornerRadius = 4.f;
    [self.btnOrder.layer setBorderWidth:1];
    [self.btnOrder.layer setBorderColor:[UIColor colorWithHexString:@"ef5f7d"].CGColor];
    self.btnCheck.layer.masksToBounds = YES;
    self.btnCheck.layer.cornerRadius = 4.f;

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)ContinueOrder:(id)sender {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[RentSelfViewController class]]) {
            RentSelfViewController *vc =(RentSelfViewController *)controller;
            [self.navigationController popToViewController:vc animated:NO];
        }
    }
}
- (IBAction)checkMyRent:(id)sender {
    MyRentPersonViewController *vc = [[MyRentPersonViewController alloc] init];
    vc.selectIndex = 1;
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
