//
//  VertificateResultViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/31.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "VertificateResultViewController.h"

@interface VertificateResultViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnPop;

@end

@implementation VertificateResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnBack.layer.masksToBounds = YES;
    self.btnBack.layer.cornerRadius = 4.f;
    [self.btnBack.layer setBorderWidth:1];
    [self.btnBack.layer setBorderColor:[UIColor colorWithHexString:@"6398f1"].CGColor];
    if (self.type == 1) {
        self.btnBack.hidden = YES;
        self.btnPop.hidden = NO;
    }else{
        self.btnPop.hidden = YES;
        self.btnBack.hidden = NO;
    }
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backToMainPage:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
