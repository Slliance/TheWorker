//
//  ApplySuccessViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/30.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "ApplySuccessViewController.h"
#import "WantedJobViewController.h"
#import "MyJobViewController.h"
@interface ApplySuccessViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UIButton *btnMyJob;

@end

@implementation ApplySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnContinue.layer setBorderColor:[UIColor colorWithHexString:@"999999"].CGColor];
    [self.btnContinue.layer setBorderWidth:1];
    [self.btnContinue.layer setMasksToBounds:YES];
    [self.btnContinue.layer setCornerRadius:4.f];
    [self.btnMyJob.layer setMasksToBounds:YES];
    [self.btnMyJob.layer setCornerRadius:4.f];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)continueAction:(id)sender {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[WantedJobViewController class]]) {
            WantedJobViewController *vc = (WantedJobViewController *)controller;
            [self.navigationController popToViewController:vc animated:YES];
        }
    }

}
- (IBAction)checkMyjob:(id)sender {
    MyJobViewController *vc = [[MyJobViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
