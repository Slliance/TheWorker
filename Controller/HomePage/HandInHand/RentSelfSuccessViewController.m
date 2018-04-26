//
//  RentSelfSuccessViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/9/1.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "RentSelfSuccessViewController.h"
#import "RentSelfViewController.h"
#import "MyRentViewController.h"
#import "MyRentPersonViewController.h"
@interface RentSelfSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;

@end

@implementation RentSelfSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnBack.layer.masksToBounds = YES;
    self.btnBack.layer.cornerRadius = 4.f;
    [self.btnBack.layer setBorderWidth:1];
    [self.btnBack.layer setBorderColor:[UIColor colorWithHexString:@"ef5f7d"].CGColor];
    self.btnCheck.layer.masksToBounds = YES;
    self.btnCheck.layer.cornerRadius = 4.f;
    
    

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backRentSelf:(id)sender {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[RentSelfViewController class]]) {
            RentSelfViewController *vc =(RentSelfViewController *)controller;
            [self.navigationController popToViewController:vc animated:NO];
        }
    }
}

- (IBAction)checkMyRent:(id)sender {
    MyRentViewController *vc = [[MyRentViewController alloc] init];
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
